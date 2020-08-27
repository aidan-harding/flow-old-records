/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 27/08/2020
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new nebc.MetadataTriggerManager(Account.SObjectType).handle();
}