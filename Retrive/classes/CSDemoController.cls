/*
 * @author : Accenture
 * @date : 2011-09-28
 */
public class CSDemoController {
       
      public static String getGenre(){
          return gamepref__c.getInstance().genre__c;
      }
      public static String getPlatform() {
          return gamepref__c.getInstance().Platform__c;
      }
   
      public static list<GameList__c> getGames() {
          return GameList__c.getall().values();
      }
       
      public static list<GameList__c> getGamesByPlatform(){
          list<gamelist__c> AllGames = getGames();
          list<gamelist__c> returnlist = new list<gamelist__c>();
          String myPlatform = getPlatform();
          for(gamelist__c Game : AllGames)
          {
              if(Game.platform__c.contains(myPlatform))
                  returnlist.add(Game);
              System.debug(returnlist.size());
          }
          return returnlist;
      }
   
      public static list<GameList__c> getGamesByGenre(){
          list<gamelist__c> AllGames = getGames();
          list<gamelist__c> returnlist = new list<gamelist__c>();
          String myGenre = getGenre();
          for(gamelist__c Game : AllGames)
          {
              if(Game.genre__c.contains(myGenre))
                  returnlist.add(Game);
          }
          return returnlist;
      }
   
      public static testmethod void test1(){
   
          Profile SysAdProfileId = [SELECT id FROM Profile
                               WHERE name = 'System Administrator'];
   
          User newUser = new User
               (username='thecircleoflife@test.com',
               lastName='myLastName', profileId=SysAdProfileId.id,
               email='foobar@a.com', alias='testUser',
               timeZoneSidKey='America/Denver',
               localeSidKey='en_CA', emailEncodingKey='UTF-8',
               languageLocaleKey='en_US');
          insert newUser;
   
          gamepref__c newUserVal =
                               new gamepref__c();
          newUserVal.setupOwnerId = newUser.id;
          newUserVal.platform__c = 'Force.com Platform';
          newUserVal.genre__c = 'Made up genre';
          insert newUserVal;
   
          GameList__c testGame =
                               new GameList__c();
          testGame.name = 'Test Game';
          testGame.genre__c = 'Made up genre';
          testGame.platform__c = 'Platform A';
         // insert testGame;
   
          GameList__c testGame2 =
                               new GameList__c();
          testGame2.name = 'Test Game2';
          testGame2.genre__c = 'Only the best';
          testGame2.platform__c = 'Force.com Platform';
          //insert testGame2;
   
          System.runAs(newUser)
          {
              list<GameList__c> myListGenre = getGamesByGenre();
              list<GameList__c> myListPlatform = getGamesByPlatform();
              for(gamelist__c Game : myListGenre)
              {
                  System.Debug(Game.name);
                  System.Assert(Game.name.equals('Test Game'));
                  System.Assert(Game.genre__c.equals('Made up genre'));
              }
              for(gamelist__c Game : myListPlatform)
              {
                  System.Assert(Game.name.equals('Test Game2'));
                  System.Assert(Game.platform__c.equals
                               ('Force.com Platform'));
              }
          }
      }
  }