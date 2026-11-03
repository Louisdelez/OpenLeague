package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class ModelChangedEvent extends Event
   {
      
      public static var MODEL_CHANGED:String = "modelChanged";
      
      private var _firstItem:String;
      
      private var _lastItem:String;
      
      private var _removedIDs:String;
      
      private var _fieldName:String;
      
      public function ModelChangedEvent()
      {
         super(ModelChangedEvent.MODEL_CHANGED,false,false);
      }
      
      public function set firstItem(param1:String) : void
      {
         this._firstItem = param1;
      }
      
      public function get firstItem() : String
      {
         return this._firstItem;
      }
      
      public function set lastItem(param1:String) : void
      {
         this._lastItem = param1;
      }
      
      public function get lastItem() : String
      {
         return this._lastItem;
      }
      
      public function set removedIDs(param1:String) : void
      {
         this._removedIDs = param1;
      }
      
      public function get removedIDs() : String
      {
         return this._removedIDs;
      }
      
      public function set fieldName(param1:String) : void
      {
         this._fieldName = param1;
      }
      
      public function get fieldName() : String
      {
         return this._fieldName;
      }
   }
}

