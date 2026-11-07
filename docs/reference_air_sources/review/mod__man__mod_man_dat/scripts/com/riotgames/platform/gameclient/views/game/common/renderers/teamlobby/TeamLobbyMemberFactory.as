package com.riotgames.platform.gameclient.views.game.common.renderers.teamlobby
{
   import blix.action.IAction;
   import blix.signals.Signal;
   import com.riotgames.rust.context.RustContext;
   import mx.core.ClassFactory;
   
   public class TeamLobbyMemberFactory
   {
      
      private static var _instance:TeamLobbyMemberFactory;
      
      private static var renderer:Class = TeamLobbyMemberRenderer;
      
      private var _haveAssetsLoaded:Boolean = false;
      
      private var _context:RustContext;
      
      private var teamLobbyPanelAssets:String = "mod/man/assets/teamLobbyPanel.swf";
      
      private var _assetsLoaded:Signal = new Signal();
      
      public function TeamLobbyMemberFactory()
      {
         super();
         this._context = new RustContext();
         var _loc1_:IAction = this._context.loadAssets(this.teamLobbyPanelAssets);
         _loc1_.getCompleted().add(this.onAssetsLoaded);
      }
      
      public static function get instance() : TeamLobbyMemberFactory
      {
         if(!_instance)
         {
            _instance = new TeamLobbyMemberFactory();
         }
         return _instance;
      }
      
      public static function createRendererFactory(param1:Object = null) : ClassFactory
      {
         if(!param1)
         {
            param1 = {};
         }
         var _loc2_:ClassFactory = new ClassFactory(renderer);
         param1.context = context;
         _loc2_.properties = param1;
         return _loc2_;
      }
      
      public static function get context() : RustContext
      {
         return instance.getContext();
      }
      
      public static function createRenderer(param1:Object) : Object
      {
         var _loc3_:String = null;
         renderer[context] = context;
         var _loc2_:Object = new renderer();
         if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
         }
         return _loc2_;
      }
      
      private function onAssetsLoaded(param1:IAction) : void
      {
         this._assetsLoaded.dispatch();
         this._haveAssetsLoaded = true;
      }
      
      public function get assetsLoaded() : Signal
      {
         return this._assetsLoaded;
      }
      
      public function get haveAssetsLoaded() : Boolean
      {
         return this._haveAssetsLoaded;
      }
      
      private function getContext() : RustContext
      {
         return this._context;
      }
   }
}

