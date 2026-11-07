package com.riotgames.platform.gameclient.events
{
   import flash.events.Event;
   
   public class RuneBookEvent extends Event
   {
      
      public static const RUNE_INVENTORY_LOADED:String = "runesLoaded";
      
      public static const RUNE_BOOK_SAVED:String = "runeBookSaved";
      
      public static const RUNE_COMBINER_COMPLETED:String = "runeCombinerCompleted";
      
      public static const RUNE_COMBINER_FAILED:String = "runeCombinerFailed";
      
      public static const RUNE_COMBINER_SUCCEEDED:String = "runeCombinerSucceeded";
      
      public static const RUNE_COMBINERS_RETRIEVED:String = "runeCombinersRetrieved";
      
      public static const RUNE_COMBINERS_RETRIEVAL_FAILED:String = "runeCombinersRetrievalFailed";
      
      public static const RUNE_BOOK_STATE_CHANGED:String = "runeBookStateChanged";
      
      public static const RUNE_BOOK_CHANGED:String = "runeBookChanged";
      
      public static const SUMMONER_CHANGED:String = "summonerChanged";
      
      public static const RUNE_BOOK_CONTROLLER_INITIALIZED:String = "runeBookControllerInitialized";
      
      public static const LOCAL_RUNE_BOOK_RETRIEVED:String = "localRuneBookRetrieved";
      
      public static const FOREIGN_RUNE_BOOK_RETRIEVED:String = "foreignRuneBookRetrieved";
      
      public static const SUMMONER_LEVEL_CHANGED:String = "summonerLevelChanged";
      
      public static const HAS_UNSAVED_EDITS_CHANGED:String = "hasUnsavedEditsChanged";
      
      public static const IS_BUSY_CHANGED:String = "isBusyChanged";
      
      private var _editing:Boolean = false;
      
      private var _combining:Boolean = false;
      
      public function RuneBookEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._combining = param3;
         this._editing = param2;
      }
      
      override public function toString() : String
      {
         return "RuneBookEvent type:" + type + " editing:" + this.editing + " combing:" + this.combining;
      }
      
      override public function clone() : Event
      {
         return new RuneBookEvent(type,this.editing,this.combining,bubbles,cancelable);
      }
      
      public function get editing() : Boolean
      {
         return this._editing;
      }
      
      public function get combining() : Boolean
      {
         return this._combining;
      }
   }
}

