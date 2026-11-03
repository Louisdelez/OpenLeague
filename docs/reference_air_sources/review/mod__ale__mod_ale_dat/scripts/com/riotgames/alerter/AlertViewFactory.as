package com.riotgames.alerter
{
   import blix.IDestructible;
   import blix.action.IAction;
   import blix.context.IContext;
   import blix.view.ILayoutElement;
   import com.riotgames.alerter.view.ErrorAlertView;
   import com.riotgames.alerter.view.MessageWithCheckBoxAlertView;
   import com.riotgames.alerter.view.StandardMessageAlertView;
   import com.riotgames.alerter.view.WaitAlertView;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertErrorAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.alerter.AlertWithCheckBoxAction;
   import com.riotgames.rust.module.RiotModuleView;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class AlertViewFactory extends RiotModuleView implements IAlertViewFactory
   {
      
      private var currentAlertViews:Dictionary = new Dictionary();
      
      public function AlertViewFactory(param1:IContext, param2:RiotModuleInfo)
      {
         super(param1);
         loadAssets(new URLRequest(param2.getPath() + "assets/alerterAssets.swf"));
      }
      
      public function showAlert(param1:IAction) : void
      {
         var _loc2_:ILayoutElement = null;
         var _loc3_:ErrorAlertView = null;
         var _loc4_:WaitAlertView = null;
         var _loc5_:MessageWithCheckBoxAlertView = null;
         var _loc6_:StandardMessageAlertView = null;
         if(param1 is AlertErrorAction)
         {
            _loc3_ = new ErrorAlertView(this);
            _loc3_.setAlertAction(AlertAction(param1));
            _loc2_ = _loc3_;
         }
         else if(param1 is AlertWaitAction)
         {
            _loc4_ = new WaitAlertView(this);
            _loc4_.setAlertAction(AlertAction(param1));
            _loc2_ = _loc4_;
         }
         else if(param1 is AlertWithCheckBoxAction)
         {
            _loc5_ = new MessageWithCheckBoxAlertView(this);
            _loc5_.setAlertAction(AlertAction(param1));
            _loc2_ = _loc5_;
         }
         else if(param1 is AlertAction)
         {
            _loc6_ = new StandardMessageAlertView(this);
            _loc6_.setAlertAction(AlertAction(param1));
            _loc2_ = _loc6_;
         }
         if(param1 is AlertAction)
         {
            this.currentAlertViews[param1] = _loc2_;
            PopUpManager.addPopUp(_loc2_,null,AlertAction(param1).isModal);
         }
      }
      
      public function hideAlert(param1:IAction) : void
      {
         var _loc2_:ILayoutElement = null;
         if(param1 in this.currentAlertViews)
         {
            _loc2_ = this.currentAlertViews[param1];
            PopUpManager.removePopUp(_loc2_);
            if(_loc2_ is IDestructible)
            {
               (_loc2_ as IDestructible).destroy();
            }
         }
      }
   }
}

