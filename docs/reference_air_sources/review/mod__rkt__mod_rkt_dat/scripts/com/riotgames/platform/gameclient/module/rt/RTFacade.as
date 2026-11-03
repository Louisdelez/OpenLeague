package com.riotgames.platform.gameclient.module.rt
{
   import com.riotgames.platform.gameclient.module.rt.model.HistoryProxy;
   import com.riotgames.platform.gameclient.module.rt.model.PlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ServiceStateProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamStatsProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.view.modal.ModalTeamMediator;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   import org.puremvc.as3.multicore.patterns.facade.Facade;
   
   public class RTFacade extends Facade implements IFacade
   {
      
      public static const NAME:String = "RTFacade";
      
      private var _rtProvider:RankedTeamsProvider;
      
      private var _statsProxy:TeamStatsProxy;
      
      public function RTFacade(param1:String)
      {
         super(param1);
         this._statsProxy = new TeamStatsProxy();
      }
      
      public static function get modalMediator() : ModalTeamMediator
      {
         return instance.retrieveMediator(ModalTeamMediator.NAME) as ModalTeamMediator;
      }
      
      public static function get historyProxy() : HistoryProxy
      {
         return instance.retrieveProxy(HistoryProxy.NAME) as HistoryProxy;
      }
      
      public static function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      public static function get profileTeamProxy() : ProfileTeamProxy
      {
         return instance.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      public static function getInstance(param1:String = "RTFacade") : IFacade
      {
         if(instanceMap[param1] == null)
         {
            instanceMap[param1] = new RTFacade(param1);
         }
         return instanceMap[param1];
      }
      
      public static function get playerProxy() : PlayerProxy
      {
         return instance.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
      }
      
      public static function get statsProxy() : TeamStatsProxy
      {
         return instance._statsProxy;
      }
      
      public static function get teamProxy() : TeamProxy
      {
         return instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      public static function get serviceStateProxy() : ServiceStateProxy
      {
         return instance.retrieveProxy(ServiceStateProxy.NAME) as ServiceStateProxy;
      }
      
      public static function get instance() : RTFacade
      {
         return RTFacade(getInstance(NAME));
      }
      
      public static function get context() : RTContext
      {
         return instance.rtProvider.context;
      }
      
      public function get rtProvider() : RankedTeamsProvider
      {
         return this._rtProvider;
      }
      
      public function set rtProvider(param1:RankedTeamsProvider) : void
      {
         this._rtProvider = param1;
      }
   }
}

