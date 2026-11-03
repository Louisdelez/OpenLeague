package com.riotgames.platform.gameclient.contextAlert
{
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class AlertParser
   {
      
      protected var alertCallback:Function = null;
      
      protected var commandDictionary:Dictionary = null;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function AlertParser(param1:Function)
      {
         super();
         this.alertCallback = param1;
         this.fillCommandDictionary();
      }
      
      protected function error(param1:String, param2:XML) : void
      {
         this.logger.error("AlertParser: invalid XML. Error: " + param1 + "\nAlertParser error line: " + param2.toString());
      }
      
      public function execute(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Function = null;
         for each(_loc2_ in param1.children())
         {
            _loc3_ = _loc2_.name().localName;
            _loc4_ = this.commandDictionary[_loc3_] as Function;
            if(_loc4_ != null)
            {
               if(Boolean(_loc4_(_loc2_)))
               {
                  this.executeItem(_loc2_);
               }
            }
            else
            {
               this.error("could not find command: " + _loc4_,_loc2_);
            }
         }
      }
      
      private function handleNewMessage(param1:XML) : Boolean
      {
         var _loc2_:String = this.parseAttribute(param1,"text");
         var _loc3_:String = this.parseAttribute(param1,"title");
         var _loc4_:String = this.parseAttribute(param1,"location");
         var _loc5_:AlertParameters = new AlertParameters();
         _loc5_.location = _loc4_;
         _loc5_.message = _loc2_;
         _loc5_.title = _loc3_;
         if(this.alertCallback != null)
         {
            this.alertCallback(_loc5_);
         }
         return true;
      }
      
      private function executeItem(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Function = null;
         for each(_loc2_ in param1.children())
         {
            _loc3_ = _loc2_.name().localName;
            _loc4_ = this.commandDictionary[_loc3_] as Function;
            if(_loc4_ != null)
            {
               if(!_loc4_(_loc2_))
               {
                  break;
               }
            }
            else
            {
               this.error("could not find command: " + _loc4_,_loc2_);
            }
         }
      }
      
      protected function parseAttribute(param1:XML, param2:String) : String
      {
         var _loc3_:String = param1[param2];
         if(_loc3_ == "" || _loc3_ == null)
         {
            this.error("could not find required attribute: " + param2,param1);
         }
         return _loc3_;
      }
      
      protected function getInt(param1:XML, param2:String = "value") : int
      {
         var _loc3_:String = this.parseAttribute(param1,param2);
         return parseInt(_loc3_);
      }
      
      protected function fillCommandDictionary() : void
      {
         this.commandDictionary = new Dictionary();
         this.commandDictionary["message"] = this.handleNewMessage;
      }
   }
}

