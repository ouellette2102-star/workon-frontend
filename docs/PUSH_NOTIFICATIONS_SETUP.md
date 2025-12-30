# Push Notifications Setup — PR-F20

## Overview

This document describes how to enable push notifications for WorkOn.

## Current Status

- **Frontend:** Ready (disabled by default via `PushConfig.enabled = false`)
- **Backend:** Endpoints need to be implemented
- **Firebase:** Needs project setup and configuration files

---

## Frontend Configuration

### 1. Enable Push Notifications

Edit `lib/services/push/push_config.dart`:

```dart
static const bool enabled = true; // Change from false to true
```

### 2. Add Firebase Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
```

### 3. Android Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create/select a project
3. Add Android app with package name: `com.example.my_project`
4. Download `google-services.json` → place in `android/app/`
5. Update `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

6. Update `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 4. iOS Setup (Optional for MVP)

1. Add iOS app in Firebase Console
2. Download `GoogleService-Info.plist` → place in `ios/Runner/`
3. Enable Push Notifications capability in Xcode
4. Configure APNs in Firebase Console

### 5. Uncomment Firebase Code

In `lib/services/push/push_service.dart`, uncomment the `_setupFCM()` method and related code.

---

## Backend Implementation

### Required Endpoints

#### 1. Register Device Token

```
POST /devices/register
Authorization: Bearer <token>
Content-Type: application/json

{
  "token": "<fcm_device_token>",
  "platform": "android" | "ios"
}
```

Response: `200 OK` or `201 Created`

#### 2. Unregister Device Token

```
DELETE /devices/unregister
Authorization: Bearer <token>
Content-Type: application/json

{
  "token": "<fcm_device_token>"
}
```

Response: `200 OK` or `204 No Content`

### Database Schema (Prisma Example)

```prisma
model DeviceToken {
  id        String   @id @default(cuid())
  userId    String
  token     String   @unique
  platform  String   // "android" or "ios"
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
}
```

### Push Service Implementation

```typescript
// src/services/push.service.ts
import * as admin from 'firebase-admin';

export class PushService {
  private static initialized = false;

  static initialize() {
    if (this.initialized) return;
    
    const serviceAccount = process.env.FIREBASE_SERVICE_ACCOUNT;
    if (!serviceAccount) {
      console.warn('[PushService] FIREBASE_SERVICE_ACCOUNT not set, push disabled');
      return;
    }

    admin.initializeApp({
      credential: admin.credential.cert(JSON.parse(serviceAccount)),
    });
    
    this.initialized = true;
    console.log('[PushService] Initialized');
  }

  static async sendToUser(userId: string, payload: {
    title: string;
    body: string;
    data?: Record<string, string>;
  }) {
    if (!this.initialized) {
      console.warn('[PushService] Not initialized, skipping push');
      return;
    }

    const tokens = await prisma.deviceToken.findMany({
      where: { userId },
      select: { token: true },
    });

    if (tokens.length === 0) return;

    const message: admin.messaging.MulticastMessage = {
      tokens: tokens.map(t => t.token),
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: payload.data,
      android: {
        notification: {
          channelId: 'workon_messages',
        },
      },
    };

    try {
      const response = await admin.messaging().sendEachForMulticast(message);
      console.log(`[PushService] Sent ${response.successCount}/${tokens.length}`);
      
      // Clean up invalid tokens
      response.responses.forEach((resp, idx) => {
        if (!resp.success && resp.error?.code === 'messaging/registration-token-not-registered') {
          prisma.deviceToken.delete({ where: { token: tokens[idx].token } });
        }
      });
    } catch (error) {
      console.error('[PushService] Send error:', error);
    }
  }
}
```

### Message Event Hook

In your messages controller, after creating a message:

```typescript
// After saving message to DB
const conversation = await prisma.conversation.findUnique({
  where: { id: conversationId },
  include: { participants: true },
});

const recipientId = conversation.participants
  .find(p => p.userId !== senderId)?.userId;

if (recipientId) {
  await PushService.sendToUser(recipientId, {
    title: senderName,
    body: message.text.slice(0, 100),
    data: {
      type: 'message',
      conversationId,
      senderName,
    },
  });
}
```

### Environment Variables

```env
# Firebase Admin SDK service account (JSON string)
FIREBASE_SERVICE_ACCOUNT={"type":"service_account","project_id":"..."}

# Or path to service account file
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
```

---

## Testing

### Manual Test Steps

1. **Device Registration**
   - Login on Android device
   - Check backend logs: device token should be registered
   - Verify in DB: `SELECT * FROM device_tokens WHERE user_id = '...'`

2. **Push Reception**
   - Send message from another user
   - Verify push notification appears on device

3. **Notification Tap**
   - Tap notification
   - Verify app opens to correct conversation

4. **Foreground Notification**
   - With app open, receive message
   - Verify snackbar appears

5. **Token Refresh**
   - Clear app data → login again
   - Verify new token registered (old one replaced or added)

6. **Logout**
   - Logout from app
   - Verify device token removed from DB

---

## Security Considerations

- **Never log FCM tokens** (they allow sending push to device)
- Validate Bearer token before registering device
- Use userId from JWT, not from request body
- Implement rate limiting on register endpoint
- Clean up stale tokens periodically

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No push received | Check FCM token is valid, backend logs |
| "google-services.json not found" | Download from Firebase Console |
| Token refresh fails | Check network, re-authenticate |
| iOS not working | Check APNs configuration |

---

## Rollback

If push notifications cause issues:

1. Set `PushConfig.enabled = false`
2. Remove Firebase dependencies (optional)
3. Device tokens will remain in DB but won't be used

