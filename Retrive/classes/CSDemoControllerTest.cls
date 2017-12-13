@isTest
public class CSDemoControllerTest {
static testmethod void TestCSDemoController() {
CSDemoController obj = new CSDemoController();
CSDemoController.getGenre();
CSDemoController.getPlatform();
CSDemoController.getGames();
CSDemoController.getGamesByPlatform();
CSDemoController.getGamesByGenre();
CSDemoController.test1();
}
}