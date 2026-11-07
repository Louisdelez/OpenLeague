package com.riotgames.pvpnet.system.alerter
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import mx.resources.ResourceManager;
   
   public class AlertAction extends BasicAction
   {
      
      public var title:String;
      
      private var _body:String;
      
      private var _bodyChanged:Signal = new Signal();
      
      public var showAffirmative:Boolean = true;
      
      public var showNegative:Boolean = false;
      
      public var affirmativeLabel:String;
      
      public var negativeLabel:String;
      
      public var affirmativeDefault:Boolean;
      
      public var data:Object;
      
      public var affirmativeResponse:Boolean;
      
      public var isModal:Boolean = true;
      
      public function AlertAction(param1:String, param2:String)
      {
         super(true);
         if(param1 == null || param1 == "null")
         {
            param2 = ResourceManager.getInstance().getString("resources","GEN-0009");
         }
         if(param2 == "null")
         {
            param2 = ResourceManager.getInstance().getString("resources","GEN-0009");
         }
         this.title = param1;
         this.body = param2;
         if(!this.showNegative)
         {
            this.affirmativeDefault = true;
         }
         this.setOkCancelLabels();
      }
      
      public function get body() : String
      {
         return this._body;
      }
      
      public function set body(param1:String) : void
      {
         this._body = param1;
         this._bodyChanged.dispatch();
      }
      
      public function getBodyChanged() : ISignal
      {
         return this._bodyChanged;
      }
      
      public function add() : void
      {
         if(getIsFinished())
         {
            reset();
         }
         AlerterProviderProxy.instance.addAlert(this);
      }
      
      public function remove() : void
      {
         AlerterProviderProxy.instance.removeAlert(this);
      }
      
      public function setOkCancelLabels() : void
      {
         this.affirmativeLabel = ResourceManager.getInstance().getString("resources","common_button_ok");
         this.negativeLabel = ResourceManager.getInstance().getString("resources","common_button_cancel");
      }
      
      public function setYesNoLabels() : void
      {
         this.affirmativeLabel = ResourceManager.getInstance().getString("resources","common_button_yes");
         this.negativeLabel = ResourceManager.getInstance().getString("resources","common_button_no");
      }
   }
}

