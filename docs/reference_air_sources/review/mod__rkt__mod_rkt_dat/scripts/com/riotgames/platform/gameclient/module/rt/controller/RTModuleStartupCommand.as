package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.model.HistoryProxy;
   import com.riotgames.platform.gameclient.module.rt.model.PlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ServiceStateProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.module.rt.view.modal.ModalTeamMediator;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTModuleStartupCommand extends RTSimpleCommand implements ICommand
   {
      
      public function RTModuleStartupCommand()
      {
         super();
      }
      
      public function registerProxies() : void
      {
         facade.registerProxy(new TeamProxy());
         facade.registerProxy(new PlayerProxy());
         facade.registerProxy(new ProfilePlayerProxy());
         facade.registerProxy(new ProfileTeamProxy());
         facade.registerProxy(new ServiceStateProxy());
         facade.registerProxy(new HistoryProxy());
      }
      
      public function registerCommands() : void
      {
         facade.registerCommand(RTSendKickCommand.KICK,RTSendKickCommand);
         facade.registerCommand(RTSendInviteCommand.INVITE,RTSendInviteCommand);
         facade.registerCommand(RTSendRevokeInviteCommand.REVOKE,RTSendRevokeInviteCommand);
         facade.registerCommand(RTRefreshProfileTeamCommand.REFRESH,RTRefreshProfileTeamCommand);
         facade.registerCommand(RTAlertCommand.ALERT,RTAlertCommand);
         facade.registerCommand(RTLeaveTeamCommand.LEAVE,RTLeaveTeamCommand);
         facade.registerCommand(RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE,RTNotifyTeamStatusUpdate);
         facade.registerCommand(RTPromoteCaptainCommand.PROMOTE,RTPromoteCaptainCommand);
         facade.registerCommand(RTShowServiceError.SHOW_ERROR,RTShowServiceError);
         facade.registerCommand(RTErrorCommand.ERROR,RTErrorCommand);
         facade.registerCommand(RTLogCommand.DEBUG,RTLogCommand);
         facade.registerCommand(RTLogCommand.ERROR,RTLogCommand);
         facade.registerCommand(RTLogCommand.FATAL,RTLogCommand);
         facade.registerCommand(RTLogCommand.INFO,RTLogCommand);
         facade.registerCommand(RTLogCommand.WARN,RTLogCommand);
      }
      
      override public function execute(param1:INotification) : void
      {
         this.registerCommands();
         this.registerProxies();
         this.startup();
         super.execute(param1);
      }
      
      public function startup() : void
      {
         facade.registerMediator(new ModalTeamMediator());
      }
   }
}

