# Configuration Architecture Decision

## Context

The WorkOn Flutter application requires a centralized configuration system to manage environment-specific settings, particularly backend API URLs for Railway deployment.

## Decision

We introduce a single, centralized configuration file at `lib/config/app_config.dart` that consolidates all environment-specific settings.

## Rationale

1. **Single Source of Truth**: All configuration values are defined in one location, eliminating scattered hardcoded values across the codebase.

2. **Environment Awareness**: The configuration automatically detects production vs. development environments using Dart's compile-time constants (`dart.vm.product`).

3. **Type Safety**: Using an abstract final class with static constants ensures compile-time safety and prevents accidental instantiation.

4. **Railway Compatibility**: Backend URLs follow Railway's standard naming convention (`*.up.railway.app`) for seamless deployment integration.

5. **Maintainability**: Future configuration changes (API versioning, timeouts, new endpoints) require modifications in only one file.

## Structure

```
lib/
└── config/
    └── app_config.dart    # Centralized configuration
```

## Usage

```dart
import 'package:work_on_v1/config/app_config.dart';

// Access the active API URL
final url = AppConfig.activeApiUrl;

// Check environment
if (AppConfig.isProduction) {
  // Production-specific logic
}

// Build full endpoint URL
final endpoint = '${AppConfig.apiUrl}/users';
```

## Consequences

### Positive

- Simplified configuration management
- Clear separation between environments
- Easy to extend with additional settings
- No runtime configuration parsing required

### Negative

- Requires rebuild to change configuration values
- Railway URLs must be updated in code for new deployments

## Status

**Accepted** — Implemented in PR#1.

## References

- Railway deployment documentation
- Flutter environment configuration best practices

