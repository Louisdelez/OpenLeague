package com.riotgames.platform.gameclient.module.services.local
{
   import blix.action.SequenceAction;
   import blix.action.sql.SQLConnectionAction;
   import blix.action.sql.SQLStatementAction;
   import flash.data.SQLMode;
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import flash.filesystem.File;
   
   public class KeybindingDAO
   {
      
      private var sqlConnectionAction:SQLConnectionAction;
      
      public function KeybindingDAO(param1:String)
      {
         super();
         var _loc2_:File = new File("app:/assets/data/gameStats/gameStats_" + param1 + ".sqlite");
         this.sqlConnectionAction = new SQLConnectionAction(_loc2_,false,SQLMode.READ);
      }
      
      public function getAllEventsResult(param1:SQLResult) : Array
      {
         return param1.data;
      }
      
      public function getAllCategoriesResult(param1:SQLResult) : Array
      {
         return param1.data;
      }
      
      public function getKeybindingCategories(param1:Function, param2:Function, param3:Function) : void
      {
         var allCategoriesAction:SQLStatementAction = null;
         var sequence:SequenceAction = null;
         var onSuccess:Function = param1;
         var onComplete:Function = param2;
         var onError:Function = param3;
         var selectAllCategories:SQLStatement = new SQLStatement();
         selectAllCategories.sqlConnection = this.sqlConnectionAction.sqlConnection;
         selectAllCategories.text = "SELECT * FROM keybindingCategories";
         allCategoriesAction = new SQLStatementAction(selectAllCategories);
         allCategoriesAction.unmarshallResultFunction = this.getAllCategoriesResult;
         sequence = new SequenceAction();
         sequence.then(this.sqlConnectionAction);
         sequence.then(allCategoriesAction);
         sequence.getCompleted().addOnce(function():void
         {
            if(onSuccess != null)
            {
               onSuccess(allCategoriesAction.unmarshalledResult);
            }
            if(onComplete != null)
            {
               onComplete();
            }
         });
         sequence.getErred().addOnce(function():void
         {
            if(onError != null)
            {
               onError(sequence.getError());
            }
            if(onComplete != null)
            {
               onComplete();
            }
         });
         sequence.invoke();
      }
      
      public function getKeybindingDefaults(param1:Function, param2:Function, param3:Function) : void
      {
         var allEventsAction:SQLStatementAction = null;
         var sequence:SequenceAction = null;
         var onSuccess:Function = param1;
         var onComplete:Function = param2;
         var onError:Function = param3;
         var selectAllEvents:SQLStatement = new SQLStatement();
         selectAllEvents.sqlConnection = this.sqlConnectionAction.sqlConnection;
         selectAllEvents.text = "SELECT * FROM keybindingEvents";
         allEventsAction = new SQLStatementAction(selectAllEvents);
         allEventsAction.unmarshallResultFunction = this.getAllEventsResult;
         sequence = new SequenceAction();
         sequence.then(this.sqlConnectionAction);
         sequence.then(allEventsAction);
         sequence.getCompleted().addOnce(function():void
         {
            if(onSuccess != null)
            {
               onSuccess(allEventsAction.unmarshalledResult);
            }
            if(onComplete != null)
            {
               onComplete();
            }
         });
         sequence.getErred().addOnce(function():void
         {
            if(onError != null)
            {
               onError(sequence.getError());
            }
            if(onComplete != null)
            {
               onComplete();
            }
         });
         sequence.invoke();
      }
   }
}

