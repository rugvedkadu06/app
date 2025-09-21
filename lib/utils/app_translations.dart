// lib/utils/app_translations.dart
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'appName': 'Janvaani',
      'createAccount': 'Create Account',
      'fullName': 'Full Name',
      'emailAddress': 'Email Address',
      'phoneNumber': 'Phone Number',
      'sendOtp': 'Send Verification Code',
      'verifyOtp': 'Verify OTP',
      'enterOtp': 'Enter OTP sent to your email',
      'otpSent': 'OTP sent to your email!',
      'faceVerification': 'Face Verification',
      'centerYourFace': 'Center your face in the oval',
      'skipForNow': 'Skip for now',
      'issues': 'Issues',
      'rewards': 'Rewards',
      'profile': 'Profile',
      'searchIssues': 'Search issues...',
      'totalCoins': 'Total Earned Coins',
      'transactions': 'Transactions',
      'redeemRewards': 'Redeem Vouchers',
      'noTransactions': 'No transaction history yet.',
      'all': 'All', 'pending': 'Pending', 'approved': 'Approved', 'inProgress': 'In Progress', 'resolved': 'Resolved',
      'noIssues': 'No issues found for this filter.',
      'issueDetails': 'Issue Details',
      'statusTracker': 'Status Tracker',
      'created': 'Report Submitted',
      'verified': 'Verified by Authority',
      'redeemPoints': 'Redeem Points',
      'pointsRedeemed': 'Points Redeemed',
      'uniqueId': 'Unique ID', 'yourStats': 'Your Statistics', 'issuesCreated': 'Issues Created',
      'issuesResolved': 'Issues Resolved', 'issuesApproved': 'Issues Approved', 'english': 'English', 'hindi': 'Hindi',
      'createIssue': 'Create New Issue', 'issueTitle': 'Issue Title', 'description': 'Description',
      'nearbyLandmark': 'Nearby Landmark', 'addPhoto': 'Add Photo', 'fetchingLocation': 'Fetching location...',
      'previewIssue': 'Preview Issue', 'confirmAndSubmit': 'Confirm & Submit', 'redeemVouchersTitle': 'Redeem Vouchers',
      'redeem': 'Redeem', 'cost': 'Cost', 'points': 'Points', 'notEnoughPoints': 'Not enough points',
      'confirmRedemption': 'Confirm Redemption', 'confirmRedemptionBody': 'Are you sure you want to spend', 'cancel': 'Cancel',
      'availableVouchers': 'Available Vouchers', 'expiredVouchers': 'Expired Vouchers', 'validTill': 'Valid Till',
      'redeemed': 'REDEEMED', 'expired': 'EXPIRED', 'logout': 'Logout'
    },
    'hi_IN': {
      'appName': 'जनवाणी', 'issues': 'समस्याएं', 'rewards': 'पुरस्कार', 'profile': 'प्रोफ़ाइल',
      'createAccount': 'अकाउंट बनाएं', 'fullName': 'पूरा नाम', 'emailAddress': 'ईमेल पता', 'phoneNumber': 'फ़ोन नंबर',
      'sendOtp': 'सत्यापन कोड भेजें', 'verifyOtp': 'ओटीपी सत्यापित करें',
      'enterOtp': 'आपके ईमेल पर भेजा गया ओटीपी दर्ज करें', 'otpSent': 'ओटीपी आपके ईमेल पर भेज दिया गया है!',
      'faceVerification': 'चेहरा सत्यापन', 'centerYourFace': 'अपने चेहरे को ओवल के बीच में रखें', 'skipForNow': 'अभी के लिए छोड़ें',
      'searchIssues': 'समस्याएं खोजें...', 'totalCoins': 'कुल अर्जित सिक्के', 'transactions': 'लेन-देन',
      'redeemRewards': 'वाउचर भुनाएं', 'noTransactions': 'अभी तक कोई लेन-देन इतिहास नहीं है।',
      'all': 'सभी', 'pending': 'लंबित', 'approved': 'अनुमोदित', 'inProgress': 'कार्यरत', 'resolved': 'हल हो गई',
      'noIssues': 'इस फ़िल्टर के लिए कोई समस्या नहीं मिली।', 'issueDetails': 'समस्या का विवरण', 'statusTracker': 'स्थिति ट्रैकर',
      'created': 'रिपोर्ट सबमिट की गई', 'verified': 'प्राधिकरण द्वारा सत्यापित', 'redeemPoints': 'अंक भुनाएं',
      'pointsRedeemed': 'अंक भुनाए गए', 'uniqueId': 'यूनिक आईडी', 'yourStats': 'आपके आँकड़े',
      'issuesCreated': 'समस्याएं बनाई गईं', 'issuesResolved': 'समस्याएं हल हुईं', 'issuesApproved': 'समस्याएं स्वीकृत हुईं',
      'english': 'अंग्रेज़ी', 'hindi': 'हिंदी', 'createIssue': 'नई समस्या बनाएं', 'issueTitle': 'समस्या का शीर्षक',
      'description': 'विवरण', 'nearbyLandmark': 'आस-पास का लैंडमार्क', 'addPhoto': 'फोटो जोड़ें',
      'fetchingLocation': 'स्थान प्राप्त हो रहा है...', 'previewIssue': 'समस्या का पूर्वावलोकन करें',
      'confirmAndSubmit': 'पुष्टि करें और सबमिट करें', 'redeemVouchersTitle': 'वाउचर भुनाएं', 'redeem': 'भुनाएं',
      'cost': 'लागत', 'points': 'अंक', 'notEnoughPoints': 'अपर्याप्त अंक', 'confirmRedemption': 'रिडेम्पशन की पुष्टि करें',
      'confirmRedemptionBody': 'क्या आप वाकई खर्च करना चाहते हैं', 'cancel': 'रद्द करें', 'availableVouchers': 'उपलब्ध वाउचर',
      'expiredVouchers': 'समय सीमा समाप्त वाउचर', 'validTill': 'तक वैध', 'redeemed': 'भुनाया गया', 'expired': 'अवधि समाप्त',
      'logout': 'लॉग आउट'
    }
  };
}


