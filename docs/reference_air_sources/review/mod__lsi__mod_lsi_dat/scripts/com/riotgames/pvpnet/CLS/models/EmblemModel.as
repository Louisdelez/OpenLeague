package com.riotgames.pvpnet.CLS.models
{
   public class EmblemModel
   {
      
      private var _title:String;
      
      private var _description:String;
      
      public function EmblemModel(param1:String, param2:String)
      {
         super();
         this._title = param1;
         this._description = param2;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
   }
}

