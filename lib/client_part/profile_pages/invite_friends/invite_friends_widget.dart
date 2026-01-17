import '/client_part/components_client/back_icon_btn/back_icon_btn_widget.dart';
import '/client_part/components_client/invite_friend_item/invite_friend_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/analytics/analytics_service.dart';
import '/services/deep_linking/deep_link_service.dart';
import '/services/auth/auth_service.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'invite_friends_model.dart';
export 'invite_friends_model.dart';

class InviteFriendsWidget extends StatefulWidget {
  const InviteFriendsWidget({super.key});

  static String routeName = 'InviteFriends';
  static String routePath = '/inviteFriends';

  @override
  State<InviteFriendsWidget> createState() => _InviteFriendsWidgetState();
}

class _InviteFriendsWidgetState extends State<InviteFriendsWidget> {
  late InviteFriendsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InviteFriendsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  wrapWithModel(
                    model: _model.backIconBtnModel,
                    updateCallback: () => safeSetState(() {}),
                    child: BackIconBtnWidget(),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      's7m05mml' /* Invite Friends */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'General Sans',
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ].divide(SizedBox(width: 15.0)),
              ),
            ].divide(SizedBox(width: 15.0)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PR-21: Invite link card
                  _buildInviteLinkCard(context),
                  const SizedBox(height: 20),
                  // Contacts section title
                  Text(
                    'Ou invite tes contacts',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 0.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      wrapWithModel(
                        model: _model.inviteFriendItemModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1682096252599-e8536cd97d2b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1683140621573-233422bfc7f1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1688350808212-4e6908a03925?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8cG9ydHJhaXR8ZW58MHwwfDB8fHww',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel4,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1564564321837-a57b7070ac4f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel5,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1722859288966-b00ef70df64b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel6,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1638727295415-286409421143?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel7,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel8,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1689539137236-b68e436248de?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjV8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel9,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjl8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel10,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://plus.unsplash.com/premium_photo-1682096475747-a744ab3f55ab?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzN8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                      wrapWithModel(
                        model: _model.inviteFriendItemModel11,
                        updateCallback: () => safeSetState(() {}),
                        child: InviteFriendItemWidget(
                          img:
                              'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzV8fHBvcnRyYWl0fGVufDB8MHwwfHx8MA%3D%3D',
                        ),
                      ),
                    ],
                  ),
                ]
                    .divide(SizedBox(height: 20.0))
                    .addToStart(SizedBox(height: 20.0))
                    .addToEnd(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// PR-21: Builds the invite link card with copy/share functionality.
  Widget _buildInviteLinkCard(BuildContext context) {
    // Generate invite link with user's referral code
    final userId = AuthService.currentUser?.id ?? '';
    final inviteLink = DeepLinkService.generateInviteLink(
      referralCode: userId.isNotEmpty ? userId.substring(0, 8) : null,
      utmSource: 'app_share',
      utmCampaign: 'invite_friends',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Partage WorkOn',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'General Sans',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Invite tes amis et gagne des récompenses!',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'General Sans',
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Link display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inviteLink,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'General Sans',
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.0,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              // Copy button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyInviteLink(context, inviteLink),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copier'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Share button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareInviteLink(inviteLink),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Partager'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: FlutterFlowTheme.of(context).primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Copies the invite link to clipboard.
  void _copyInviteLink(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lien copié!'),
        backgroundColor: FlutterFlowTheme.of(context).success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shares the invite link using the system share sheet.
  void _shareInviteLink(String link) {
    // PR-23: Track invite shared
    AnalyticsService.track(AnalyticsEvent.inviteShared);
    Share.share(
      'Rejoins-moi sur WorkOn! Trouve des missions près de chez toi ou propose tes services.\n\n$link',
      subject: 'Invitation WorkOn',
    );
  }
}
