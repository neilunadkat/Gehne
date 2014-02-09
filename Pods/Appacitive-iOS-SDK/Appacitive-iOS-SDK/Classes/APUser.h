//
//  APUser.h
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 07/01/13.
//  Copyright (c) 2013 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APResponseBlocks.h"
#import "APObject.h"

/**
 An APUser is a user registerd for using your app. This class helps you to manage the details of the users of your app.
 */
@interface APUser : APObject <APObjectPropertyMapping> {
}

@property (nonatomic, strong, readonly) NSString *userToken;
@property (nonatomic, readonly) BOOL loggedInWithFacebook;
@property (nonatomic, readonly) BOOL loggedInWithTwitter;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *secretQuestion;
@property (nonatomic, strong) NSString *isEmailVerified;
@property (nonatomic, strong) NSString *isEnabled;
@property (nonatomic, strong) NSString *isOnline;

-(instancetype)init;

/**
 Returns the current authenticated user.
 
 @return APUser or nil
 */
+ (APUser*) currentUser;

/**
 Helper method to set the current user.
 
 @param user The new current user
 */
+ (void) setCurrentUser:(APUser*) user;

/** @name Authenticating a user */

/**
 @see authenticateUserWithUserName:password:successHandler:failureHandler:
 */
+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APUserSuccessBlock) successBlock;

/**
 Method to authenticate a user
 
 If successful the currentUser is set to the authenticated user.
 
 @param userName The username of the user to authenticate.
 @param password The password of the user to authenticate.
 @param successBlock Block invoked when authentication is successful.
 @param failureBlock Block invoked when authentication is unsuccessful.
 */
+ (void) authenticateUserWithUserName:(NSString*)userName password:(NSString*) password successHandler:(APUserSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see authenticateUserWithFacebook:successHandler:failureHandler:
 */
+ (void) authenticateUserWithFacebook:(NSString *)accessToken successHandler:(APUserSuccessBlock) successBlock;

/**
 Method to authenticate a user with facebook.
 
 If successful the currentUser is set to the authenticated user.
 
 @param accessToken The access token retrieved after a succesful facebook login.
 @param successBlock Block invoked when authentication with facebook is successful.
 @param failureBlock Block invoked when authentication with facebook is unsuccessful.
 */
+ (void) authenticateUserWithFacebook:(NSString *)accessToken successHandler:(APUserSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see authenticateUserWithTwitter:oauthSecret:successHandler:failureHandler:
 */
+ (void) authenticateUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APUserSuccessBlock) successBlock;

/**
 Method to authenticate a user with Twitter.
 
 If successful the currentUser is set to the authenticated user.
 
 @param oauthToken The oauth token retrieved after twitter login.
 @param oauthSecret The oauth secret.
 @param successBlock Block invoked when login with twitter is successful.
 @param failureBlock Block invoked when login with twitter is unsuccessful.
 */
+ (void) authenticateUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APUserSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see authenticateUserWithTwitter:oauthSecret:consumerKey:consumerSecret:successHandler:failureHandler:
 */
+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APUserSuccessBlock)successBlock;

/**
 Method to authenticate a user with Twitter.
 
 If successful the currentUser is set to the authenticated user.
 
 @param oauthToken The oauth token retrieved after twitter login.
 @param oauthSecret The oauth secret.
 @param consumerKey The consumer key of the application created on twitter.
 @param consumerSecret The consumer secret of the application created on twitter.
 @param successBlock Block invoked when authentication with twitter is successful.
 @param failureBlock Block invoked when authentication with twitter is unsuccessful.
 */
+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APUserSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Create a new user */

/**
 @see createUserWithSuccessHandler:failureHandler:
 */
- (void) createUserWithSuccessHandler:(APSuccessBlock) successBlock;

/**
 Method to create a new user
 
 If successful the an object of APUser is returned in the successBlock.
 
 @note This method does not set the current user as the new user.
 
 @param successBlock Block invoked when the create request is successful.
 @param failureBlock Block invoked when the create request is unsuccessful.
 */
- (void) createUserWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see createUserWithFacebook:successHandler:failureHandler:
 */
- (void) createUserWithFacebook:(NSString*)token;

/**
 @see createUserWithFacebook:successHandler:failureHandler:
 */
- (void) createUserWithFacebook:(NSString*)token failureHandler:(APFailureBlock)failureBlock;

/**
 Method to create a user with Facebook.
 
 @param token The access token retrieved after a succesful facebook login.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) createUserWithFacebook:(NSString*)token successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see createUserWithTwitter:oauthSecret:consumerKey:consumerSecret:successHandler:failureHandler:
 */
- (void) createUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*)consumerSecret;

/**
 @see createUserWithTwitter:oauthSecret:consumerKey:consumerSecret:successHandler:failureHandler:
 */
- (void) createUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*)consumerSecret failureHandler:(APFailureBlock)failureBlock;

/**
 Method to create a user with twitter token and secret.
 
 @param oauthToken The oauth token retrieved after twitter login.
 @param oauthSecret The oauth secret.
 @param consumerKey The consumer key of the application created on twitter.
 @param consumerSecret The consumer secret of the application created on twitter.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) createUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Save APUser objects */

/**
 @see saveObjectWithSuccessHandler:failureHandler:
 */
- (void) saveObject;

/**
 @see saveObjectWithSuccessHandler:failureHandler:
 */
- (void) saveObjectWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Save the object on the remote server.
 
 This method will save an object in the background. If save is successful the properties will be updated and the successBlock will be invoked. If not the failure block is invoked.
 
 @param successBlock Block invoked when the save operation is successful
 @param failureBlock Block invoked when the save operation fails.
 
 */
- (void) saveObjectWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Fetch APUser */

/**
 @see fetchUserById:successHandler:failureHandler:
 */
- (void) fetchUserById:(NSString *)userId;

/**
 @see fetchUserById:successHandler:failureHandler:
 */
- (void) fetchUserById:(NSString *)userId successHandler:(APSuccessBlock) successBlock;

/**
 Method to retrieve User by ID
 
 @param userId The user Id of an existing user whose details need to be retrieved.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) fetchUserById:(NSString *)userId successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see fetchUserByUserName:successHandler:failureHandler:
 */
- (void) fetchUserByUserName:(NSString *)userName;

/**
 @see fetchUserByUserName:successHandler:failureHandler:
 */
- (void) fetchUserByUserName:(NSString *)userName successHandler:(APSuccessBlock) successBlock;

/**
 Method to retrieve User by userName
 
 @param userName The user name of an existing user  whose details need to be retrieved.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) fetchUserByUserName:(NSString *)userName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see fetchUserWithUserToken:successHandler:failureHandler:
 */
- (void) fetchUserWithUserToken:(NSString *)userToken;

/**
 @see fetchUserWithUserToken:successHandler:failureHandler:
 */
- (void) fetchUserWithUserToken:(NSString *)userToken successHandler:(APSuccessBlock) successBlock;

/**
 Method to retrieve of currently logged-in User
 
 @param userToken user token for the user you wish to fetch.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) fetchUserWithUserToken:(NSString *)userToken successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see fetchWithSuccessHandler:failureHandler:
 */
- (void) fetch;

/**
 @see fetchWithSuccessHandler:failureHandler:
 */
- (void) fetchWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Method used to fetch an APObject.
 
 This method will use the type and objectId properties to fetch the object. If the objectId and type is not set, results are unexpected.
 
 @param failureBlock Block invoked when the fetch operation fails.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) fetchWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Method to retrieve a User object with query string
 
 @param queryString SQL kind of query to search for specific objects. For more info http://appacitive.com
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) fetchWithQueryString:(NSString*)queryString successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;


/** @name Update User */

/**
 @see updateObjectWithRevisionNumber:successHandler:failureHandler:
 */
- (void) updateObject;

/**
 @see updateObjectWithRevisionNumber:successHandler:failureHandler:
 */
- (void) updateObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 Method to update a User
 
 @param revision The the last revision number of the object.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) updateObjectWithRevisionNumber:(NSNumber*)revision successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/** @name Delete User */

/**
 @see deleteObjectWithSuccessHandler:failureHandler:
 */
- (void) deleteObject;

/**
 Method to delete a User
 
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see deleteObjectWithConnectingConnectionsSuccessHandler:failureHandler:
 */
- (void) deleteObjectWithConnectingConnections;

/**
 @see deleteObjectWithConnectingConnectionsSuccessHandler:failureHandler:
 */
- (void) deleteObjectWithConnectingConnections:(APFailureBlock)failureBlock;

/**
 Deletes an APObject along with any connections it has.
 
 @param successBlock Block invoked when delete operation is successful.
 @param failureBlock Block invoked when delete operation is unsuccessful.
 */
- (void) deleteObjectWithConnectingConnectionsSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see deleteObjectWithUserName:successHandler:failureHandler:
 */
- (void) deleteObjectWithUserName:(NSString*)userName;

/**
 Method to delete a User
 
 @param userName The username of the user whose details need to be deleted.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) deleteObjectWithUserName:(NSString*)userName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see deleteCurrentlyLoggedInUserWithSuccessHandler:failureHandler:
 */
+ (void) deleteCurrentlyLoggedInUser;

/**
 Method to delete the currently logged-in User
 
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
+ (void) deleteCurrentlyLoggedInUserWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see setUserLocationToLatitude:longitude:forUserWithUserId:successHandler:failureHandler:
 */
+ (void) setUserLocationToLatitude:(NSString*)latitude longitude:(NSString*)longitude forUserWithUserId:(NSString*)userId;

/**
 @see setUserLocationToLatitude:longitude:forUserWithUserId:successHandler:failureHandler:
 */
+ (void) setUserLocationToLatitude:(NSString*)latitude longitude:(NSString*)longitude forUserWithUserId:(NSString*)userId failureHandler:(APFailureBlock)failureBlock;

/**
 Method to set user's location
 
 @param latitude Latitude of the user's current location coordinate.
 @param longitude Longitude of the user's current location coordinate.
 @param userId the id of the user whose location needs to be set.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
+ (void) setUserLocationToLatitude:(NSString*)latitude longitude:(NSString*)longitude forUserWithUserId:(NSString*)userId successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see validateCurrentUserSessionWithSuccessHandler:failureHandler:
 */
+ (void) validateCurrentUserSessionWithSuccessHandler:(APResultSuccessBlock)successBlock;

/**
 Method to validate user's session
 
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
+ (void) validateCurrentUserSessionWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see logOutCurrentUserWithSuccessHandler:failureHandler:
 */
+ (void) logOutCurrentUser;

/**
 @see logOutCurrentUserWithSuccessHandler:failureHandler:
 */
+ (void) logOutCurrentUserWithFailureHandler:(APFailureBlock)failureBlock;

/**
 Method to invalidate user's session
 
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
+ (void) logOutCurrentUserWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock;

/**
 @see changePasswordFromOldPassword:toNewPassword:successHandler:failureHandler:
 */
- (void) changePasswordFromOldPassword:(NSString*)oldPassword toNewPassword:(NSString*)newPassword;

/**
 @see changePasswordFromOldPassword:toNewPassword:successHandler:failureHandler:
 */
- (void) changePasswordFromOldPassword:(NSString*)oldPassword toNewPassword:(NSString*)newPassword failureHandler:(APFailureBlock)failureBlock;

/**
 Method to change Password for the currently logged-in user
 
 @param oldPassword The current/old password of the logged-in user.
 @param newPassword The new password of the logged-in user.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) changePasswordFromOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

/**
 @see sendResetPasswordEmailWithSubject:successHandler:failureHandler:
 */
- (void) sendResetPasswordEmailWithSubject:(NSString*)emailSubject;

/**
 @see sendResetPasswordEmailWithSubject:successHandler:failureHandler:
 */
- (void) sendResetPasswordEmailWithSubject:(NSString*)emailSubject failureHandler:(APFailureBlock)failureBlock;

/**
 Method to send a reset password email for the currently logged-in user
 
 @param emailSubject text for the subject field of the reset password email.
 @param successBlock Block invoked when operation is successful.
 @param failureBlock Block invoked when operation is unsuccessful.
 */
- (void) sendResetPasswordEmailWithSubject:(NSString *)emailSubject successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock;

@end
