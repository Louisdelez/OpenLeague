package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.vo.ErrorMessageVO;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTErrorCommand extends RTSimpleCommand
   {
      
      public static const ERROR:String = "RTErrorCommand";
      
      public var errorVO:ErrorMessageVO;
      
      public function RTErrorCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.errorVO = ErrorMessageVO(param1.getBody());
         var _loc2_:AlertAction = new AlertAction(this.errorVO.getTitle(),this.errorVO.getBody());
         _loc2_.add();
         sendNotification(RTLogCommand.ERROR,this.errorVO.getTitle() + this.errorVO.getBody());
      }
   }
}

