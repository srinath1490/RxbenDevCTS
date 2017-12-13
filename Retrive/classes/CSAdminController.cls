/*
 * @author : Accenture
 * @date : 2011-09-28
 */
public class CSAdminController {
       
  public gamepref__c myPref {get;set;}
       
          public CSAdminController(){
          myPref = gamepref__c.getvalues(System.UserInfo.getUserId());
          if(myPref == null)
              myPref = new gamepref__c(setupOwnerId =
                                       System.Userinfo.getUserId());
      }
       
      public static String getPlatform() {
          return gamepref__c.getInstance().Platform__c;
      }
   
      public static String getGenre(){
          return gamepref__c.getInstance().genre__c;
      }
       
      public static String getPlatformValue() {
          if(gamepref__c.getValues(System.Userinfo.getUserId())
                                      == null){
              return 'You do not have a personal gaming preference set';
          }
          else if(gamepref__c.getValues(System.Userinfo.getUserId()).
                                         platform__c == null){
              return 'You did not set a personal preferred platform';
          }
          return gamepref__c.getValues(System.Userinfo.getUserId()).Platform__c;
      }
   
      public static String getGenreValue(){
          if(gamepref__c.getValues(System.Userinfo.getUserId())
                                   == null){
              return 'You do not have a personal gaming preference set';
          }
          else if(gamepref__c.getValues(System.Userinfo.getUserId()).
                                        genre__c == null){
              return 'You did not set a personal preferred genre';
          }        return gamepref__c.getValues(System.Userinfo.getUserId()).genre__c;
      }
   
      public PageReference save() {
          if(myPref.id == null){
              insert myPref;
          }
          else
              update myPref;
          return null;
      }
   
  }