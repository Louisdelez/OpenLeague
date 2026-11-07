package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class DisplayInviteErrorAlertAction extends BasicAction
   {
      
      private var _args:Array;
      
      private var _errorKey:String;
      
      public function DisplayInviteErrorAlertAction(param1:String, param2:Array)
      {
         super(false);
         this._errorKey = param1;
         this._args = param2;
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:String = _loc1_.getString("resources",MessageDictionary.INVITE_ERROR_TITLE);
         var _loc3_:String = _loc1_.getString("resources",this._errorKey,this._args);
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
         _erred.dispatch(new Error(_loc3_));
      }
   }
}

