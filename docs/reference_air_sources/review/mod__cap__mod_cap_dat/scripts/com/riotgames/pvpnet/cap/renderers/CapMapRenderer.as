package com.riotgames.pvpnet.cap.renderers
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPositions;
   import com.riotgames.pvpnet.cap.renderers.player.CapPlayerRendererBase;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class CapMapRenderer extends CapPlayerRendererBase
   {
      
      private static const CHAMPION_IMAGE_SIZE:int = 36;
      
      private static const CAPTAIN_ICONS_ENABLED:Boolean = false;
      
      private var activeTween:TweenLite;
      
      public var jungleRendererRemote:SpriteProxy;
      
      private var isFadingOut:Boolean = false;
      
      public var ringRendererRemote:SpriteProxy;
      
      public var ringRendererLocal:SpriteProxy;
      
      private var soundProvider:ISoundProvider;
      
      public var jungleRendererLocal:SpriteProxy;
      
      public var captainRendererRemote:SpriteProxy;
      
      public var championImage:MovieClipProxy;
      
      public var captainRendererLocal:SpriteProxy;
      
      public function CapMapRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("MapIcon");
         setVisible(false);
         this.updateChildren();
      }
      
      override public function getIncludeInLayout() : Boolean
      {
         return true;
      }
      
      private function shouldBeVisible(param1:CapPlayerSelection) : Boolean
      {
         if(!param1 || param1.position == null)
         {
            return false;
         }
         var _loc2_:String = param1.currentState;
         if(_loc2_ == CapPlayerSelection.INTRO_STATE)
         {
            return false;
         }
         if(_loc2_ == CapPlayerSelection.FIND_PLAYERS_STATE)
         {
            return false;
         }
         return true;
      }
      
      private function onPositionChanged() : void
      {
         this.updateVisibility();
         if(this.isFadingOut)
         {
            return;
         }
         if(playerSelection.position)
         {
            this.soundProvider.play(CapAudioKeys.CAP_MAP_CHANGE_POSITION);
         }
         this.updateJungleRenderers();
      }
      
      override public function destroy() : void
      {
         if(this.activeTween)
         {
            this.activeTween.complete();
         }
         super.destroy();
      }
      
      override protected function updateState() : void
      {
         setCurrentState(playerSelection.currentState);
      }
      
      override protected function subscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         super.subscribeToDataChanges(param1);
         if(param1)
         {
            param1.mapCoordinatesChanged.add(invalidateLayout);
            param1.summonerNameChanged.add(this.updateVisibility);
            param1.currentStateChanged.add(this.updateVisibility);
            param1.currentStateChanged.add(this.updateState);
            param1.championChanged.add(this.onChampionChanged);
            param1.positionChanged.add(this.onPositionChanged);
            param1.isCaptainChanged.add(this.onCaptainChanged);
         }
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.soundProvider = getDependency(ISoundProvider);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.championImage = new MovieClipProxy(this);
         this.championImage.setWidth(CHAMPION_IMAGE_SIZE);
         this.championImage.setHeight(CHAMPION_IMAGE_SIZE);
         setTimelineChildByName("portrait",this.championImage);
         this.jungleRendererLocal = new SpriteProxy(this);
         setTimelineChildByName("jungleRendererLocal",this.jungleRendererLocal);
         this.jungleRendererLocal.setVisible(false);
         this.jungleRendererRemote = new SpriteProxy(this);
         setTimelineChildByName("jungleRendererRemote",this.jungleRendererRemote);
         this.jungleRendererRemote.setVisible(false);
         this.ringRendererLocal = new SpriteProxy(this);
         setTimelineChildByName("localPlayerRingRenderer",this.ringRendererLocal);
         this.ringRendererLocal.setVisible(false);
         this.ringRendererRemote = new SpriteProxy(this);
         setTimelineChildByName("remotePlayerRingRenderer",this.ringRendererRemote);
         this.captainRendererLocal = new SpriteProxy(this);
         setTimelineChildByName("captainRendererLocal",this.captainRendererLocal);
         this.captainRendererLocal.setVisible(false);
         this.captainRendererRemote = new SpriteProxy(this);
         setTimelineChildByName("captainRendererRemote",this.captainRendererRemote);
         this.captainRendererRemote.setVisible(false);
      }
      
      private function fadeOut(param1:SpriteProxy, param2:Number = 1) : void
      {
         var target:SpriteProxy = param1;
         var duration:Number = param2;
         if(!target.getVisible())
         {
            return;
         }
         if(!UserPreferencesManager.userPrefs.enableAnimations)
         {
            target.setAlpha(0);
            target.setVisible(false);
            this.isFadingOut = false;
         }
         else
         {
            if(this.activeTween)
            {
               this.activeTween.pause();
            }
            this.isFadingOut = true;
            target.setAlpha(1);
            target.setVisible(true);
            if(target.getAsset())
            {
               this.activeTween = TweenLite.to(target.getAsset(),duration,{
                  "alpha":0,
                  "onComplete":function():void
                  {
                     target.setAlpha(0);
                     target.setVisible(false);
                     isFadingOut = false;
                  }
               });
               this.activeTween.play();
            }
         }
      }
      
      private function updateJungleRenderers() : void
      {
         if(Boolean(playerSelection) && playerSelection.position == CapPositions.JUNGLE)
         {
            if(playerSelection.isLocalPlayer)
            {
               this.fadeIn(this.jungleRendererLocal,1,false);
               this.jungleRendererRemote.setVisible(false);
            }
            else
            {
               this.fadeIn(this.jungleRendererRemote,1,false);
               this.jungleRendererLocal.setVisible(false);
            }
         }
         else
         {
            this.fadeOut(this.jungleRendererRemote);
            this.fadeOut(this.jungleRendererLocal);
         }
      }
      
      private function fadeIn(param1:SpriteProxy, param2:Number = 1, param3:Boolean = true) : void
      {
         var target:SpriteProxy = param1;
         var duration:Number = param2;
         var playSound:Boolean = param3;
         if(target.getVisible())
         {
            return;
         }
         if(!UserPreferencesManager.userPrefs.enableAnimations)
         {
            target.setAlpha(1);
            target.setVisible(true);
            this.isFadingOut = false;
         }
         else
         {
            if(this.activeTween)
            {
               this.activeTween.pause();
            }
            this.isFadingOut = false;
            target.setAlpha(0);
            target.setVisible(true);
            this.updateChildren();
            if(playSound)
            {
               this.soundProvider.play(CapAudioKeys.CAP_MAP_FADE_IN);
            }
            if(target.getAsset())
            {
               this.activeTween = TweenLite.to(target.getAsset(),duration,{
                  "alpha":1,
                  "onComplete":function():void
                  {
                     target.setAlpha(1);
                  }
               });
               this.activeTween.play();
            }
         }
      }
      
      override protected function updateChildren() : void
      {
         super.updateChildren();
         this.updateChampionImage();
         this.updateJungleRenderers();
         this.updateRingRenderers();
         this.updateCaptainRenderers();
         this.updateVisibility();
      }
      
      protected function get position() : Point
      {
         if(Boolean(playerSelection) && Boolean(playerSelection.mapCoordinates))
         {
            return playerSelection.mapCoordinates;
         }
         return null;
      }
      
      private function onChampionChanged() : void
      {
         if(this.isFadingOut || playerSelection.champion == null && playerSelection.isInvitedPlayer)
         {
            return;
         }
         this.updateChampionImage();
      }
      
      private function onCaptainChanged() : void
      {
         if(this.isFadingOut)
         {
            return;
         }
         this.updateCaptainRenderers();
      }
      
      override public function getExplicitPosition() : Point
      {
         if(this.position)
         {
            return this.position;
         }
         return new Point(0,0);
      }
      
      override protected function unsubscribeToDataChanges(param1:CapPlayerSelection) : void
      {
         super.unsubscribeToDataChanges(param1);
         if(param1)
         {
            param1.mapCoordinatesChanged.remove(invalidateLayout);
            param1.summonerNameChanged.remove(this.updateVisibility);
            param1.currentStateChanged.remove(this.updateVisibility);
            param1.currentStateChanged.remove(this.updateState);
            param1.championChanged.remove(this.onChampionChanged);
            param1.positionChanged.remove(this.onPositionChanged);
            param1.isCaptainChanged.remove(this.onCaptainChanged);
         }
      }
      
      private function updateCaptainRenderers() : void
      {
         if(Boolean(playerSelection) && Boolean(playerSelection.isCaptain) && CAPTAIN_ICONS_ENABLED)
         {
            if(playerSelection.isLocalPlayer)
            {
               this.fadeIn(this.captainRendererLocal);
               this.captainRendererRemote.setVisible(false);
            }
            else
            {
               this.fadeIn(this.captainRendererRemote);
               this.captainRendererLocal.setVisible(false);
            }
         }
         else
         {
            this.captainRendererRemote.setVisible(false);
            this.captainRendererLocal.setVisible(false);
         }
      }
      
      private function updateRingRenderers() : void
      {
         if(this.isFadingOut)
         {
            return;
         }
         if(Boolean(playerSelection) && playerSelection.isLocalPlayer)
         {
            this.ringRendererLocal.setVisible(true);
            this.ringRendererRemote.setVisible(false);
         }
         else
         {
            this.ringRendererLocal.setVisible(false);
            this.ringRendererRemote.setVisible(true);
         }
      }
      
      private function updateChampionImage() : void
      {
         var _loc1_:Champion = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Bitmap = null;
         var _loc4_:BitmapProxy = null;
         this.championImage.removeAllChildren();
         if(Boolean(playerSelection) && Boolean(playerSelection.champion))
         {
            _loc1_ = playerSelection.champion;
            _loc2_ = ChampionIconCacheUtil.instance.getIcon(_loc1_.skinName);
            _loc3_ = new Bitmap(_loc2_);
            _loc3_.width = CHAMPION_IMAGE_SIZE;
            _loc3_.height = CHAMPION_IMAGE_SIZE;
            _loc4_ = new BitmapProxy(this,_loc3_);
            this.championImage.addChild(_loc4_);
            _loc4_.setSmoothing(true);
         }
      }
      
      protected function updateVisibility() : void
      {
         if(this.shouldBeVisible(playerSelection))
         {
            this.fadeIn(this);
         }
         else
         {
            this.fadeOut(this);
         }
      }
   }
}

