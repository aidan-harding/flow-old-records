/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 27/08/2020
 */

@IsTest
private class FlowOldRecordsTest {

    @IsTest
    static void testBehavior() {
        String nameBefore = 'ACME';
        String nameAfter = 'ACME!';

        Account testAccount = new Account(Name = 'ACME');
        insert testAccount;

        Test.startTest();
        testAccount.Name = nameAfter;
        update testAccount;
        Test.stopTest();

        List<Account> beforeAccounts = FlowOldRecords.getOldRecord(new List<Account> {testAccount});
        System.assertEquals(nameBefore, beforeAccounts[0].Name);
    }
}