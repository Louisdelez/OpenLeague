package com.riotgames.platform.gameclient.module.rt.view
{
   import com.riotgames.platform.gameclient.components.containers.LazyViewstack;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.view.common.IActivatableView;
   import com.riotgames.platform.gameclient.module.rt.view.header.ProfileHeaderBG;
   import com.riotgames.platform.gameclient.module.rt.view.header.ProfileHeaderBar;
   import com.riotgames.platform.gameclient.module.rt.view.history.HistoryView;
   import com.riotgames.platform.gameclient.module.rt.view.intro.IntroTeamView;
   import com.riotgames.platform.gameclient.module.rt.view.manage.ManageTeamView;
   import com.riotgames.platform.gameclient.module.rt.view.modal.ModalTeamMediator;
   import com.riotgames.platform.gameclient.module.rt.view.profile.ProfileTeamView;
   import com.riotgames.platform.gameclient.module.rt.view.stats.TeamStatsView;
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   
   public class RTModuleShell extends Canvas
   {
      
      private var _1316821033shellContent:LazyViewstack;
      
      private var _historyView:HistoryView;
      
      private var _profileTeamView:ProfileTeamView;
      
      private var _introTeamView:IntroTeamView;
      
      private var inited:Boolean = false;
      
      private var _manageTeamView:ManageTeamView;
      
      private var context:RTContext;
      
      private var _statsView:TeamStatsView;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":1102,
               "height":550,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":ProfileHeaderBG,
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":48,
                        "y":0
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":LazyViewstack,
                  "id":"shellContent",
                  "events":{"creationComplete":"__shellContent_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":1102,
                        "height":552,
                        "x":48,
                        "y":0,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "clipContent":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ProfileHeaderBar,
                  "id":"profileHeaderBar",
                  "events":{"creationComplete":"__profileHeaderBar_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":48,
                        "y":0
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":UIComponent,
                  "id":"popupHolder",
                  "events":{"creationComplete":"__popupHolder_creationComplete"}
               })]
            };
         }
      });
      
      private var _1861377693profileHeaderBar:ProfileHeaderBar;
      
      private var _228981112popupHolder:UIComponent;
      
      public function RTModuleShell()
      {
         super();
         mx_internal::_document = this;
         this.width = 1102;
         this.height = 550;
         this.x = 51;
         this.clipContent = false;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("creationComplete",this.___RTModuleShell_Canvas1_creationComplete);
         this.addEventListener("initialize",this.___RTModuleShell_Canvas1_initialize);
      }
      
      public function __popupHolder_creationComplete(param1:FlexEvent) : void
      {
         this.onPopupHolderReady();
      }
      
      private function onPopupHolderReady() : void
      {
         this.context.setTooltipRoot(this.popupHolder);
      }
      
      public function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      public function goToHistory() : void
      {
         this.goto(this.historyTeamView,ProfileHeaderBar.STATE_HISTORY);
      }
      
      private function joinReady() : void
      {
         if(Boolean(this.profileHeaderBar) && Boolean(this.shellContent) && !this.inited)
         {
            this.inited = true;
            this.registerMediator();
            if((Boolean(RTFacade.profileTeamProxy.team) || Boolean(RTFacade.teamProxy.isTeamPending)) && !RTFacade.profileTeamProxy.isDataOnly)
            {
               this.shellContent.content = this.profileTeamView;
            }
            else
            {
               this.shellContent.content = this.introTeamView;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileHeaderBar() : ProfileHeaderBar
      {
         return this._1861377693profileHeaderBar;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      public function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      public function goToProfile() : void
      {
         this.goto(this.profileTeamView,ProfileHeaderBar.STATE_PROFILE);
      }
      
      private function get manageTeamView() : ManageTeamView
      {
         if(!this._manageTeamView)
         {
            this._manageTeamView = new ManageTeamView(this.context);
         }
         return this._manageTeamView;
      }
      
      public function goToIntro() : void
      {
         this.goto(this.introTeamView,ProfileHeaderBar.STATE_INTRO);
      }
      
      public function __shellContent_creationComplete(param1:FlexEvent) : void
      {
         this.joinReady();
      }
      
      [Bindable(event="propertyChange")]
      public function get shellContent() : LazyViewstack
      {
         return this._1316821033shellContent;
      }
      
      public function ___RTModuleShell_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function get introTeamView() : IntroTeamView
      {
         if(!this._introTeamView)
         {
            this._introTeamView = new IntroTeamView(this.context);
         }
         return this._introTeamView;
      }
      
      private function registerMediator() : void
      {
         RTFacade.instance.removeMediator(RTModuleShellMediator.NAME);
         RTFacade.instance.registerMediator(new RTModuleShellMediator(RTModuleShellMediator.NAME,this));
      }
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
         this.joinReady();
      }
      
      public function __profileHeaderBar_creationComplete(param1:FlexEvent) : void
      {
         this.joinReady();
      }
      
      private function getCurrentContent() : UIComponent
      {
         if(this.shellContent != null)
         {
            return this.shellContent.content;
         }
         return this._statsView;
      }
      
      public function get modalMediator() : ModalTeamMediator
      {
         return RTFacade.instance.retrieveMediator(ModalTeamMediator.NAME) as ModalTeamMediator;
      }
      
      public function set profileHeaderBar(param1:ProfileHeaderBar) : void
      {
         var _loc2_:Object = this._1861377693profileHeaderBar;
         if(_loc2_ !== param1)
         {
            this._1861377693profileHeaderBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileHeaderBar",_loc2_,param1));
         }
      }
      
      private function setCurrentContent(param1:UIComponent) : void
      {
         if(this.shellContent != null)
         {
            this.shellContent.removeAllChildren();
            this.shellContent.content = null;
            this.shellContent.content = param1;
         }
      }
      
      public function goToManage() : void
      {
         this.goto(this.manageTeamView,ProfileHeaderBar.STATE_MANAGE);
      }
      
      public function onInitialize() : void
      {
         this.context = RTFacade.context;
      }
      
      public function set shellContent(param1:LazyViewstack) : void
      {
         var _loc2_:Object = this._1316821033shellContent;
         if(_loc2_ !== param1)
         {
            this._1316821033shellContent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shellContent",_loc2_,param1));
         }
      }
      
      private function get historyTeamView() : HistoryView
      {
         if(!this._historyView)
         {
            this._historyView = new HistoryView(this.context);
         }
         return this._historyView;
      }
      
      public function ___RTModuleShell_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete(param1);
      }
      
      public function goToStats() : void
      {
         this.statsView.isLeague = false;
         this.goto(this.statsView,ProfileHeaderBar.STATE_STATS);
      }
      
      private function goto(param1:IActivatableView, param2:String) : void
      {
         var _loc3_:IActivatableView = null;
         if(this.getCurrentContent is IActivatableView)
         {
            _loc3_ = this.getCurrentContent as IActivatableView;
            _loc3_.deactivate();
         }
         this.setCurrentContent(param1 as UIComponent);
         param1.activate();
         if(this.profileHeaderBar != null)
         {
            this.profileHeaderBar.setState(param2);
         }
      }
      
      public function get statsView() : TeamStatsView
      {
         if(!this._statsView)
         {
            if(this.context == null)
            {
               this.onInitialize();
            }
            this._statsView = new TeamStatsView(this.context);
            this.registerMediator();
         }
         return this._statsView;
      }
      
      public function get profileTeamProxy() : ProfileTeamProxy
      {
         return RTFacade.instance.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      private function get profileTeamView() : ProfileTeamView
      {
         if(!this._profileTeamView)
         {
            this._profileTeamView = new ProfileTeamView(this.context);
         }
         return this._profileTeamView;
      }
      
      public function set popupHolder(param1:UIComponent) : void
      {
         var _loc2_:Object = this._228981112popupHolder;
         if(_loc2_ !== param1)
         {
            this._228981112popupHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"popupHolder",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get popupHolder() : UIComponent
      {
         return this._228981112popupHolder;
      }
   }
}

