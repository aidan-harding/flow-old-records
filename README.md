# Old Record Access in Flow

In an Apex trigger, it is very useful to read information from the old records i.e. the state before the change that 
caused the trigger. Perhaps we directly need an old value; perhaps we want to write an 
efficient trigger that only takes action when a field has changed to a value we care about. Both of these are 
common uses in Apex. 

In the Summer 20 release, triggered Flows do not have access to the old record context of the trigger.

We can get the old records in a before-save Flow by querying the current records from the database. This costs a query,
but it works. However, before-save Flows do not allow us to save records to the database or run actions from the Flow.
They are ideal for same-object updates, where we modify the records being processed in the trigger before they hit the 
database, but not suitable for anything else.

This project demonstrates how we can cache the old records in Apex, and then provide access to them in Flow via an 
InvocableMethod.

## The Flow

There is a trivial Flow in this package to demonstrate the functionality. It looks for changes in Account name and 
posts the old and new name to chatter.

You can try it by simply renaming an Account and looking the Chatter. You will see the built-in message, plus one from the Flow.

## The Apex

The Apex code uses our ([Nebula Consulting's](https://nebulaconsulting.co.uk/)) [trigger framework](https://bitbucket.org/nebulaconsulting/nebula-core), driven by custom metadata. 

We would need to configure 
the trigger to run on any object where Flow requires access to the old records. For our framework, this just means 
adding a trivial handler trigger like [AccountTrigger](force-app/main/default/triggers/AccountTrigger.trigger) 
(which may already exist if there is other Apex) and a [metadata record](force-app/main/default/customMetadata/nebc__Trigger_Handler.AccountFlowOldRecordsBU.md-meta.xml).

The actual implementation in [FlowOlderRecords](force-app/main/default/classes/FlowOldRecords.cls) and very 
straightforward. It simply builds up a map of `SObjectType` to `Map<Id, SObject>` containing the old records. This is 
stored in a static variable so that it is available later in the transaction.

The InvocableMethod simply returns results from the map.

## Can I Save The Query In Before-Save Flows?

No - the [order of execution](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_order_of_execution.htm)
tells us that before-save Flows run before Apex, so you'll still need to query the records in the Flow. 

## So, Should I Do This?

Maybe?

Certainly, if you want to, you can take the ideas from this code and put it in your own context.

Generally, we prefer not to mix Flow and Apex on the same object. But, if the only Apex is for this purpose, that seems OK.
If it leads to writing large ingenious Flows, then that's the point to take a step back and consider Apex instead.

There certainly seems to be a class of moderately-sized flows where this would be useful.      