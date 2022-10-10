import { NativeModules, Platform } from "react-native";

export default class SalesforceChatAPI {
  constructor() {
    this.salesforceChat = NativeModules.RNSalesforceChat;
  }

  throwRequiredFieldError(field) {
    throw new Error(`required field ${field}`);
  }

  isInvalidBooleanParam(param) {
    return param === undefined || param === null;
  }

  async createPreChatData({
    agentLabel,
    value,
    isDisplayedToAgent,
    transcriptFields,
    preChatDataKey,
  }) {
    if (!agentLabel) {
      this.throwRequiredFieldError("agentLabel");
    }
    if (this.isInvalidBooleanParam(isDisplayedToAgent)) {
      this.throwRequiredFieldError("isDisplayedToAgent");
    }
    if (!preChatDataKey) {
      this.throwRequiredFieldError("preChatDataKey");
    }

    if (!value) value = null;
    if (!transcriptFields) transcriptFields = null;

    this.salesforceChat.createPreChatData(
      agentLabel,
      value,
      isDisplayedToAgent,
      transcriptFields,
      preChatDataKey
    );
  }

  async createEntityField({
    objectFieldName,
    doCreate,
    doFind,
    isExactMatch,
    preChatDataKeyToMap,
    entityFieldKey,
  }) {
    if (!objectFieldName) this.throwRequiredFieldError("objectFieldName");

    if (this.isInvalidBooleanParam(doCreate)) {
      this.throwRequiredFieldError("doCreate");
    }
    if (this.isInvalidBooleanParam(doFind)) {
      this.throwRequiredFieldError("doFind");
    }
    if (this.isInvalidBooleanParam(isExactMatch)) {
      this.throwRequiredFieldError("isExactMatch");
    }
    if (!entityFieldKey) {
      this.throwRequiredFieldError("entityFieldKey");
    }

    if (!preChatDataKeyToMap) preChatDataKeyToMap = null;

    this.salesforceChat.createEntityField(
      objectFieldName,
      doCreate,
      doFind,
      isExactMatch,
      preChatDataKeyToMap,
      entityFieldKey
    );
  }

  async createEntity({
    objectType,
    linkToTranscriptField,
    showOnCreate,
    entityFieldKeysToMap,
  }) {
    if (!objectType) this.throwRequiredFieldError("objectType");
    if (this.isInvalidBooleanParam(showOnCreate)) {
      this.throwRequiredFieldError("showOnCreate");
    }

    if (!linkToTranscriptField) linkToTranscriptField = null;
    if (!entityFieldKeysToMap) entityFieldKeysToMap = null;

    this.salesforceChat.createEntity(
      objectType,
      linkToTranscriptField,
      showOnCreate,
      entityFieldKeysToMap
    );
  }

  async configureChat({
    orgId,
    buttonId,
    deploymentId,
    liveAgentPod,
    visitorName,
    defaultToMinimized = true,
    navbarBackground = "#FAFAFA",
    navbarInverted = "#010101",
    brandPrimary = "#007F7F",
    brandSecondary = "#2872CC",
    brandPrimaryInverted = "#FBFBFB",
    brandSecondaryInverted = "#FCFCFC",
    contrastPrimary = "#000000",
    contrastSecondary = "#6D6D6D",
    contrastTertiary = "#BABABA",
    contrastQuaternary = "#F1F1F1",
    contrastInverted = "#FFFFFF",
    feedbackPrimary = "#E74C3C",
    feedbackSecondary = "#2ECC71",
    feedbackTertiary = "#F5A623",
    overlay = "#000000",
    navbarBackgroundDark = "#1A2129",
    navbarInvertedDark = "#C6CBCF",
    brandPrimaryDark = "#00B4B4",
    brandSecondaryDark = "#0070D2",
    brandPrimaryInvertedDark = "#FBFBFB",
    brandSecondaryInvertedDark = "#F7F7F7",
    contrastPrimaryDark = "#E2E4E6",
    contrastSecondaryDark = "#898D92",
    contrastTertiaryDark = "#A0A6AD",
    contrastQuaternaryDark = "#09121B",
    contrastInvertedDark = "#323232",
    feedbackPrimaryDark = "#E0A7A9",
    feedbackSecondaryDark = "#9ACDB7",
    feedbackTertiaryDark = "#FADBAE",
    overlayDark = "#323232",
  }) {
    if (!orgId) this.throwRequiredFieldError("orgId");
    if (!buttonId) this.throwRequiredFieldError("buttonId");
    if (!deploymentId) this.throwRequiredFieldError("deploymentId");
    if (!liveAgentPod) this.throwRequiredFieldError("liveAgentPod");

    if (Platform.OS === "android") {
      this.salesforceChat.configureChat(
        orgId,
        buttonId,
        deploymentId,
        liveAgentPod,
        visitorName,
        defaultToMinimized
      );
    } else {
      this.salesforceChat.configureChat(
        orgId,
        buttonId,
        deploymentId,
        liveAgentPod,
        visitorName,
        defaultToMinimized,
        navbarBackground,
        navbarInverted,
        brandPrimary,
        brandSecondary,
        brandPrimaryInverted,
        brandSecondaryInverted,
        contrastPrimary,
        contrastSecondary,
        contrastTertiary,
        contrastQuaternary,
        contrastInverted,
        feedbackPrimary,
        feedbackSecondary,
        feedbackTertiary,
        overlay,
        navbarBackgroundDark,
        navbarInvertedDark,
        brandPrimaryDark,
        brandSecondaryDark,
        brandPrimaryInvertedDark,
        brandSecondaryInvertedDark,
        contrastPrimaryDark,
        contrastSecondaryDark,
        contrastTertiaryDark,
        contrastQuaternaryDark,
        contrastInvertedDark,
        feedbackPrimaryDark,
        feedbackSecondaryDark,
        feedbackTertiaryDark,
        overlayDark
      );
    }
  }

  async openChat(failureCallback, successCallback) {
    this.salesforceChat.openChat(failureCallback, successCallback);
  }
}
