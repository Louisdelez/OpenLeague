package
{
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.module.metrics.controller.MetricsController;
   import com.riotgames.platform.gameclient.module.metrics.controller.SessionMetrics;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.tracker.Tracker;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.errors.DradisUncaughtErrorTracker;
   import com.riotgames.pvpnet.tracking.logs.DradisLogTarget;
   import com.riotgames.pvpnet.tracking.services.DradisServiceLoggerTarget;
   import com.riotgames.pvpnet.tracking.trackers.CrossModuleTrackerController;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import mx.logging.LogEventLevel;
   import mx.modules.ModuleBase;
   
   public class ClientModuleMetrics extends ModuleBase implements IProviderModule
   {
      
      private var _metricsController:MetricsController = new MetricsController();
      
      private var dradisLogTarget:DradisLogTarget;
      
      private var uncaughtErrorTracker:DradisUncaughtErrorTracker;
      
      private var crossModuleTrackerController:CrossModuleTrackerController;
      
      private var sessionMetrics:SessionMetrics;
      
      private var serviceLoggerTarget:DradisServiceLoggerTarget;
      
      public function ClientModuleMetrics()
      {
         super();
         this.crossModuleTrackerController = new CrossModuleTrackerController(this._metricsController);
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.crossModuleTrackerController.getChatTracker();
         this.crossModuleTrackerController.getFriendListBehaviorTracker();
         this.crossModuleTrackerController.getSessionTracker();
         ProviderLookup.publishProvider(IMetricsProvider,this._metricsController);
         Tracker.metricsProvider = this._metricsController;
         this.dradisLogTarget = new DradisLogTarget(this._metricsController);
         this.dradisLogTarget.level = LogEventLevel.WARN;
         LogManager.instance.addLogTarget(this.dradisLogTarget);
         this.uncaughtErrorTracker = new DradisUncaughtErrorTracker(this._metricsController);
         this.serviceLoggerTarget = new DradisServiceLoggerTarget(this._metricsController);
         ServiceLogger.addTarget(this.serviceLoggerTarget);
         this.sessionMetrics = new SessionMetrics();
         ProviderLookup.publishProvider(ISessionMetricsProvider,this.sessionMetrics);
         ProviderLookup.publishProvider(ICrossModuleTrackerProvider,this.crossModuleTrackerController);
      }
   }
}

