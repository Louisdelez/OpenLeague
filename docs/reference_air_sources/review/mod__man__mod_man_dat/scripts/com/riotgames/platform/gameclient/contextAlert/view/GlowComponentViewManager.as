package com.riotgames.platform.gameclient.contextAlert.view
{
   import com.riotgames.platform.gameclient.components.effects.BrightnessEffect;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentParameters;
   import com.riotgames.platform.gameclient.controllers.game.GlowTarget;
   import mx.binding.utils.ChangeWatcher;
   import mx.effects.Effect;
   import mx.effects.Glow;
   import mx.effects.Parallel;
   import mx.effects.Sequence;
   import mx.events.PropertyChangeEvent;
   
   public class GlowComponentViewManager
   {
      
      private var glowTarget:GlowTarget = null;
      
      private var activeGlowWatcher:ChangeWatcher = null;
      
      public var glowComponentConroller:GlowComponentController;
      
      private var glowEffect:Effect = null;
      
      public function GlowComponentViewManager(param1:GlowComponentController)
      {
         super();
         this.glowComponentConroller = param1;
      }
      
      private function createGlowTarget(param1:GlowTarget) : void
      {
         this.glowTarget = param1;
         this.glowEffect = this.createGlowEffect(param1.parameters);
         this.glowEffect.play([this.glowTarget.displayTarget]);
      }
      
      private function onActiveGlowChanged(param1:PropertyChangeEvent) : void
      {
         this.updateGlows();
      }
      
      private function createGlowEffect(param1:GlowComponentParameters) : Effect
      {
         var _loc2_:Sequence = new Sequence();
         _loc2_.repeatCount = 0;
         var _loc3_:Parallel = new Parallel();
         var _loc4_:Glow = new Glow();
         _loc4_.alphaFrom = param1.alphaFrom;
         _loc4_.alphaTo = param1.alphaTo;
         _loc4_.blurXFrom = _loc4_.blurYFrom = param1.blurFrom;
         _loc4_.blurXTo = _loc4_.blurYTo = param1.blurTo;
         _loc4_.color = param1.color;
         _loc4_.duration = param1.duration;
         var _loc5_:BrightnessEffect = new BrightnessEffect();
         _loc5_.duration = param1.duration;
         _loc5_.brightnessFrom = param1.brightnessFrom;
         _loc5_.brightnessTo = param1.brightnessTo;
         var _loc6_:BrightnessEffect = new BrightnessEffect();
         _loc6_.duration = param1.duration;
         _loc6_.brightnessFrom = param1.brightnessTo;
         _loc6_.brightnessTo = param1.brightnessFrom;
         _loc3_.addChild(_loc4_);
         _loc3_.addChild(_loc5_);
         _loc2_.addChild(_loc3_);
         var _loc7_:Glow = new Glow();
         _loc7_.alphaFrom = param1.alphaTo;
         _loc7_.alphaTo = param1.alphaFrom;
         _loc7_.blurXFrom = _loc7_.blurYFrom = param1.blurTo;
         _loc7_.blurXTo = _loc7_.blurYTo = param1.blurFrom;
         _loc7_.color = param1.color;
         _loc7_.duration = param1.duration;
         var _loc8_:Parallel = new Parallel();
         _loc8_.addChild(_loc7_);
         _loc8_.addChild(_loc6_);
         _loc2_.addChild(_loc8_);
         return _loc2_;
      }
      
      public function deactivate() : void
      {
         if(this.activeGlowWatcher != null)
         {
            this.activeGlowWatcher.unwatch();
            this.activeGlowWatcher = null;
         }
      }
      
      public function activate() : void
      {
         if(this.activeGlowWatcher == null)
         {
            this.activeGlowWatcher = ChangeWatcher.watch(this.glowComponentConroller,"activeGlow",this.onActiveGlowChanged);
         }
      }
      
      private function updateGlows() : void
      {
         if(this.glowTarget == null)
         {
            if(this.glowComponentConroller.activeGlow == null)
            {
               return;
            }
         }
         else if(Boolean(this.glowComponentConroller.activeGlow) && this.glowComponentConroller.activeGlow.displayTarget == this.glowTarget.displayTarget)
         {
            return;
         }
         if(this.glowTarget != null)
         {
            this.destroyGlowTarget();
         }
         if(this.glowComponentConroller.activeGlow)
         {
            this.createGlowTarget(this.glowComponentConroller.activeGlow);
         }
      }
      
      private function destroyGlowTarget() : void
      {
         this.glowEffect.end();
         this.glowEffect.targets = [];
         this.glowTarget.displayTarget.filters = [];
         this.glowEffect = null;
         this.glowTarget = null;
      }
   }
}

