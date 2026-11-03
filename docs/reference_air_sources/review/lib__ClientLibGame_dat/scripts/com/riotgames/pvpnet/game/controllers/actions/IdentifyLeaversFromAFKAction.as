package com.riotgames.pvpnet.game.controllers.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class IdentifyLeaversFromAFKAction extends BasicAction
   {
      
      private var _statusString:String;
      
      private var _logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _leavers:ArrayCollection;
      
      private var _teamOne:ArrayCollection;
      
      private var _teamTwo:ArrayCollection;
      
      public function IdentifyLeaversFromAFKAction(param1:String, param2:ArrayCollection, param3:ArrayCollection)
      {
         this._statusString = param1;
         this._teamOne = param2;
         this._teamTwo = param3;
         super(true);
      }
      
      override protected function doInvocation() : void
      {
         var _loc2_:IParticipant = null;
         var _loc3_:ArrayCollection = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this._teamOne)
         {
            _loc1_.addItem(_loc2_);
         }
         for each(_loc2_ in this._teamTwo)
         {
            _loc1_.addItem(_loc2_);
         }
         _loc3_ = new ArrayCollection();
         if(this._statusString != null)
         {
            _loc4_ = this._statusString.split("");
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_] == "0" || _loc4_[_loc5_] == "2")
               {
                  _loc3_.addItem(_loc1_[_loc5_]);
               }
               _loc5_++;
            }
         }
         this._leavers = _loc3_;
      }
      
      public function get leavers() : ArrayCollection
      {
         return this._leavers;
      }
   }
}

