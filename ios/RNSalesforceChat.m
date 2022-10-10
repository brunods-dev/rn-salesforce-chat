#import "RNSalesforceChat.h"

@implementation RNSalesforceChat

NSMutableDictionary<NSString *, SCSPrechatObject *>* prechatFields;
NSMutableDictionary<NSString *, SCSPrechatEntityField *>* prechatEntities;
NSMutableArray* entities;

SCSChatConfiguration *chatConfiguration;

NSString* ChatSessionStateChanged = @"ChatSessionStateChanged";
NSString* ChatSessionEnd = @"ChatSessionEnd";

NSString* Connecting = @"Connecting";
NSString* Queued = @"Queued";
NSString* Connected = @"Connected";
NSString* Ending = @"Ending";
NSString* Disconnected = @"Disconnected";

NSString* EndReasonUser = @"EndReasonUser";
NSString* EndReasonAgent = @"EndReasonAgent";
NSString* EndReasonNoAgentsAvailable = @"EndReasonNoAgentsAvailable";
NSString* EndReasonTimeout = @"EndReasonTimeout";
NSString* EndReasonSessionError = @"EndReasonSessionError";

RCT_EXPORT_MODULE()

+(void) initialize
{
    prechatFields = [[NSMutableDictionary alloc] init];
    prechatEntities = [[NSMutableDictionary alloc] init];
    entities = [[NSMutableArray alloc] init];
}

#pragma mark - RCTBridgeModule

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
  // Convert hex string to an integer
  unsigned int hexint = [self intFromHexString:hexStr];

  // Create a color object, specifying alpha as well
  UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    blue:((CGFloat) (hexint & 0xFF))/255
    alpha:alpha];

  return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
  unsigned int hexInt = 0;
  // Create scanner
  NSScanner *scanner = [NSScanner scannerWithString:hexStr];
  // Tell scanner to skip the # character
  [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
  // Scan hex value
  [scanner scanHexInt:&hexInt];
  return hexInt;
}

- (NSDictionary *)constantsToExport
{
  return @{
      ChatSessionStateChanged:ChatSessionStateChanged,
      ChatSessionEnd: ChatSessionEnd,
      Connecting: Connecting,
      Queued: Queued,
      Connected: Connected,
      Ending: Ending,
      Disconnected: Disconnected,
      EndReasonUser: EndReasonUser,
      EndReasonAgent: EndReasonAgent,
      EndReasonNoAgentsAvailable: EndReasonNoAgentsAvailable,
      EndReasonTimeout: EndReasonTimeout,
      EndReasonSessionError: EndReasonSessionError
  };
}

RCT_EXPORT_METHOD(createPreChatData:(NSString *)agentLabel value:(NSString *)value
                  isDisplayedToAgent:(BOOL)isDisplayedToAgent transcriptFields:(NSArray<NSString *> *)transcriptFields
                  preChatDataKey:(NSString *)preChatDataKey)
{
    SCSPrechatObject* prechatObject = [[SCSPrechatObject alloc] initWithLabel:agentLabel value:value];
    prechatObject.displayToAgent = isDisplayedToAgent;

    if (transcriptFields != nil) {
        NSMutableArray* receivedTranscriptFields = [transcriptFields mutableCopy];
        prechatObject.transcriptFields = receivedTranscriptFields;
    }

    prechatFields[preChatDataKey] = prechatObject;
}

RCT_EXPORT_METHOD(createEntityField:(NSString *)objectFieldName doCreate:(BOOL)doCreate doFind:(BOOL)doFind
                  isExactMatch:(BOOL)isExactMatch preChatDataKeyToMap:(NSString *)preChatDataKeyToMap
                  entityFieldKey:(NSString *)entityFieldKey)
{
    if (prechatFields[preChatDataKeyToMap] != nil) {

        SCSPrechatEntityField* entityField = [[SCSPrechatEntityField alloc] initWithFieldName:objectFieldName
                                                                                        label:prechatFields[preChatDataKeyToMap].label];
        entityField.doFind = doFind;
        entityField.doCreate = doCreate;
        entityField.isExactMatch = isExactMatch;

        prechatEntities[entityFieldKey] = entityField;
    }
}

RCT_EXPORT_METHOD(createEntity:(NSString *)objectType linkToTranscriptField:(NSString *)linkToTranscriptField
                  showOnCreate:(BOOL)showOnCreate entityFieldKeysToMap:(NSArray<NSString *> *)entityFieldKeysToMap)
{
    SCSPrechatEntity* entity = [[SCSPrechatEntity alloc] initWithEntityName:objectType];
    entity.showOnCreate = showOnCreate;

    if (linkToTranscriptField != nil) {
        entity.saveToTranscript = linkToTranscriptField;
    }

    for (id entityFieldKey in entityFieldKeysToMap) {
        if (prechatEntities[entityFieldKey] != nil) {
            [entity.entityFieldsMaps addObject:prechatEntities[entityFieldKey]];
        }
    }

    [entities addObject:entity];
}

RCT_EXPORT_METHOD(configureChat:(NSString *)orgId buttonId:(NSString *)buttonId deploymentId:(NSString *)deploymentId
                  liveAgentPod:(NSString *)liveAgentPod visitorName:(NSString *)visitorName defaultToMinimized:(BOOL *)defaultToMinimized)
{
    chatConfiguration = [[SCSChatConfiguration alloc] initWithLiveAgentPod:liveAgentPod orgId:orgId
                                                              deploymentId:deploymentId buttonId:buttonId];

    // Create appearance configuration instance
    SCAppearanceConfiguration *appearance = [SCAppearanceConfiguration new];

    NSString *navbarBackground = @"#FFFFFF";
    NSString *navbarInverted = @"#070708";
    NSString *brandPrimary = @"#6B0CC5";
    NSString *brandSecondary = @"#9E00FF";
    NSString *brandPrimaryInverted = @"#FFFFFF";
    NSString *brandSecondaryInverted = @"#FFFFFF";
    NSString *contrastPrimary = @"#070708";
    NSString *contrastSecondary = @"#979C9E";
    NSString *contrastTertiary = @"#CDCFD0";
    NSString *contrastQuaternary = @"#F2F4F5";
    NSString *contrastInverted = @"#FFFFFF";
    NSString *feedbackPrimary = @"#B10017";
    NSString *feedbackSecondary = @"#5AE69C";
    NSString *feedbackTertiary = @"#F7DD72";
    NSString *overlay = @"#000000";

    NSString *navbarBackgroundDark = @"#2B2A2E";
    NSString *navbarInvertedDark = @"#E3E5E5";
    NSString *brandPrimaryDark = @"#9E00FF";
    NSString *brandSecondaryDark = @"#AF5CF6";
    NSString *brandPrimaryInvertedDark = @"#FFFFFF";
    NSString *brandSecondaryInvertedDark = @"#FFFFFF";
    NSString *contrastPrimaryDark = @"#E3E5E5";
    NSString *contrastSecondaryDark = @"#979C9E";
    NSString *contrastTertiaryDark = @"#CDCFD0";
    NSString *contrastQuaternaryDark = @"#070708";
    NSString *contrastInvertedDark = @"#2B2A2E";
    NSString *feedbackPrimaryDark = @"#EFB8BD";
    NSString *feedbackSecondaryDark = @"#9DFFD3";
    NSString *feedbackTertiaryDark = @"#FFEFB0";
    NSString *overlayDark = @"##000000";

    if( @available(iOS 12.0, *) && UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
      //is dark
      // // navbarBackground
      [appearance setColor:[self getUIColorObjectFromHexString:navbarBackgroundDark alpha:1] forName:SCSAppearanceColorTokenNavbarBackground];
      // // navbarInverted
      [appearance setColor:[self getUIColorObjectFromHexString:navbarInvertedDark alpha:1] forName:SCSAppearanceColorTokenNavbarInverted];
      // brandPrimary
      [appearance setColor:[self getUIColorObjectFromHexString:brandPrimaryDark alpha:1] forName:SCSAppearanceColorTokenBrandPrimary];
      // brandSecondary
      [appearance setColor:[self getUIColorObjectFromHexString:brandSecondaryDark alpha:1] forName:SCSAppearanceColorTokenBrandSecondary];
      // brandPrimaryInverted
      [appearance setColor:[self getUIColorObjectFromHexString:brandPrimaryInvertedDark alpha:1] forName:SCSAppearanceColorTokenBrandPrimaryInverted];
      // brandSecondaryInverted
      [appearance setColor:[self getUIColorObjectFromHexString:brandSecondaryInvertedDark alpha:1] forName:SCSAppearanceColorTokenBrandSecondaryInverted];
      // contrastPrimary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastPrimaryDark alpha:1] forName:SCSAppearanceColorTokenContrastPrimary];
      // contrastSecondary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastSecondaryDark alpha:1] forName:SCSAppearanceColorTokenContrastSecondary];
      // contrastTertiary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastTertiaryDark alpha:1] forName:SCSAppearanceColorTokenContrastTertiary];
      // contrastQuaternary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastQuaternaryDark alpha:1] forName:SCSAppearanceColorTokenContrastQuaternary];
      // contrastInverted
      [appearance setColor:[self getUIColorObjectFromHexString:contrastInvertedDark alpha:1] forName:SCSAppearanceColorTokenContrastInverted];
      // feedbackPrimary
      [appearance setColor:[self getUIColorObjectFromHexString:feedbackPrimaryDark alpha:1] forName:SCSAppearanceColorTokenFeedbackPrimary];
      // feedbackSecondary
      [appearance setColor:[self getUIColorObjectFromHexString:feedbackSecondaryDark alpha:1] forName:SCSAppearanceColorTokenFeedbackSecondary];
      // feedbackTertiary
      [appearance setColor:[self getUIColorObjectFromHexString:feedbackTertiaryDark alpha:1] forName:SCSAppearanceColorTokenFeedbackTertiary];
      // overlay
      [appearance setColor:[self getUIColorObjectFromHexString:overlayDark alpha:.4] forName:SCSAppearanceColorTokenOverlay];

    }else{
      //is light
      // // navbarBackground
      [appearance setColor:[self getUIColorObjectFromHexString:navbarBackground alpha:1] forName:SCSAppearanceColorTokenNavbarBackground];
      // // navbarInverted
      [appearance setColor:[self getUIColorObjectFromHexString:navbarInverted alpha:1] forName:SCSAppearanceColorTokenNavbarInverted];
      // brandPrimary
      [appearance setColor:[self getUIColorObjectFromHexString:brandPrimary alpha:1] forName:SCSAppearanceColorTokenBrandPrimary];
      // brandSecondary
      [appearance setColor:[self getUIColorObjectFromHexString:brandSecondary alpha:1] forName:SCSAppearanceColorTokenBrandSecondary];
      // brandPrimaryInverted
      [appearance setColor:[self getUIColorObjectFromHexString:brandPrimaryInverted alpha:1] forName:SCSAppearanceColorTokenBrandPrimaryInverted];
      // brandSecondaryInverted
      [appearance setColor:[self getUIColorObjectFromHexString:brandSecondaryInverted alpha:1] forName:SCSAppearanceColorTokenBrandSecondaryInverted];
      // contrastPrimary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastPrimary alpha:1] forName:SCSAppearanceColorTokenContrastPrimary];
      // contrastSecondary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastSecondary alpha:1] forName:SCSAppearanceColorTokenContrastSecondary];
      // contrastTertiary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastTertiary alpha:1] forName:SCSAppearanceColorTokenContrastTertiary];
      // contrastQuaternary
      [appearance setColor:[self getUIColorObjectFromHexString:contrastQuaternary alpha:1] forName:SCSAppearanceColorTokenContrastQuaternary];
      // contrastInverted
      [appearance setColor:[self getUIColorObjectFromHexString:contrastInverted alpha:1] forName:SCSAppearanceColorTokenContrastInverted];
      // feedbackPrimary
      [appearance setColor:[self getUIColorObjectFromHexString:feedbackPrimary alpha:1] forName:SCSAppearanceColorTokenFeedbackPrimary];
      // feedbackSecondary
      [appearance setColor:[self getUIColorObjectFromHexString:feedbackSecondary alpha:1] forName:SCSAppearanceColorTokenFeedbackSecondary];
      // feedbackTertiary
      [appearance setColor:[self getUIColorObjectFromHexString:feedbackTertiary alpha:1] forName:SCSAppearanceColorTokenFeedbackTertiary];
      // overlay
      [appearance setColor:[self getUIColorObjectFromHexString:overlay alpha:.4] forName:SCSAppearanceColorTokenOverlay];

    }

    // Save configuration instance
    [SCServiceCloud sharedInstance].appearanceConfiguration = appearance;

    if (visitorName != nil) chatConfiguration.visitorName = visitorName;
    chatConfiguration.prechatFields = [prechatFields allValues];
    chatConfiguration.prechatEntities = entities;
    chatConfiguration.defaultToMinimized = defaultToMinimized;
}

RCT_EXPORT_METHOD(openChat:(RCTResponseSenderBlock)failureCallback successCallback:(RCTResponseSenderBlock)successCallback)
{
    if (chatConfiguration == nil) {
        failureCallback(@[@"error - chat not configured"]);
        return;
    }

    [[SCServiceCloud sharedInstance].chatCore removeDelegate:self];
    [[SCServiceCloud sharedInstance].chatCore addDelegate:self];
    [[SCServiceCloud sharedInstance].chatUI showChatWithConfiguration:chatConfiguration];
    successCallback(@[[NSNull null]]);
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[ChatSessionEnd, ChatSessionStateChanged];
}

#pragma mark - SCSChatSessionDelegate

- (void)session:(id<SCSChatSession>)session didTransitionFromState:(SCSChatSessionState)previous toState:(SCSChatSessionState)current {

    NSString *state;

    switch (current) {
        case SCSChatSessionStateConnecting:
            state = Connecting;
            break;
        case SCSChatSessionStateQueued:
            state = Queued;
            break;
        case SCSChatSessionStateConnected:
            state = Connected;
            break;
        case SCSChatSessionStateEnding:
            state = Ending;
            break;
        default:
            state = Disconnected;
            break;
    }
    [self sendEventWithName:ChatSessionStateChanged body:@{@"state": state}];
}

- (void)session:(id<SCSChatSession>)session didEnd:(SCSChatSessionEndEvent *)endEvent {

    NSString *endReason;

    switch (endEvent.reason) {
        case SCSChatEndReasonUser:
            endReason = EndReasonUser;
            break;
        case SCSChatEndReasonAgent:
            endReason = EndReasonAgent;
            break;
        case SCSChatEndReasonNoAgentsAvailable:
            endReason = EndReasonNoAgentsAvailable;
            break;
        case SCSChatEndReasonTimeout:
            endReason = EndReasonTimeout;
            break;
        default:
            endReason = EndReasonSessionError;
    }

    [self sendEventWithName:ChatSessionEnd body:@{@"reason": endReason}];
}


- (void)session:(id<SCSChatSession>)session didError:(NSError *)error fatal:(BOOL)fatal {
    // not used
}

@end
