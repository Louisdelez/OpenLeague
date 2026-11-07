package com.riotgames.pvpnet.runes.views.combiner
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.ds.IListX;
   import com.greensock.TweenLite;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneCombinerViewController;
   import com.riotgames.pvpnet.runes.views.common.RuneImageRenderer;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RuneCombinerCircleView extends StatefulView
   {
      
      private static const NUM_SLOTS:uint = 5;
      
      private var combineButton:LabelButtonX;
      
      private var runeSlots:Vector.<RuneCombinerSlotView>;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      private var rM:IResourceManager = ResourceManager.getInstance();
      
      private var rewardRenderer:RuneImageRenderer;
      
      private var _runesTracker:IRunesTracker;
      
      private var _showingReward:Boolean;
      
      private var rewardTweenFadeTimer:Timer;
      
      private var postRewardResetTimer:Timer;
      
      private var _toolTipManager:IToolTipManager;
      
      private var _soundProvider:ISoundProvider;
      
      public function RuneCombinerCircleView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._runesTracker = getDependency(IRunesTracker);
         this.runeCombinerViewController = getDependency(RuneCombinerViewController);
         this._soundProvider = getDependency(ISoundProvider);
         this._toolTipManager = getDependency(IToolTipManager);
      }
      
      override protected function createChildren() : void
      {
         var _loc3_:RuneCombinerSlotView = null;
         super.createChildren();
         this.runeSlots = new Vector.<RuneCombinerSlotView>(NUM_SLOTS,true);
         var _loc1_:uint = 0;
         while(_loc1_ < NUM_SLOTS)
         {
            _loc3_ = new RuneCombinerSlotView(this,_loc1_);
            setTimelineChildByName("slot" + _loc1_,_loc3_);
            this.runeSlots[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.combineButton = new LabelButtonX(this);
         this.combineButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleCombinerMouseOver);
         this.combineButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleCombinerMouseOut);
         setTimelineChildByName("combineButton",this.combineButton);
         var _loc2_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("rewardSizer",_loc2_);
         this.rewardRenderer = new RuneImageRenderer(this);
         setTimelineChildByName("rewardRenderer",this.rewardRenderer);
         this.rewardRenderer.setRuneEffectGlowActive(false);
         this.rewardRenderer.setSizer(_loc2_);
         this.disableCombine();
         this.updateRuneSlots();
         this.rewardTweenFadeTimer = new Timer(1000,1);
         this.rewardTweenFadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRewardTweenFadeTimerComplete);
         this.postRewardResetTimer = new Timer(2000,1);
         this.postRewardResetTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPostRewardResetTimerComplete);
         this.combineButton.addEventListener(MouseEvent.CLICK,this.onCombineButtonClicked);
         this.runeCombinerViewController.getRuneCombinerViewActiveChanged().add(this.onRuneCombinerViewActiveChanged);
         this.runeCombinerViewController.getRuneAddedToCombiner().add(this.updateRuneSlots);
         this.runeCombinerViewController.getRuneRemovedFromCombiner().add(this.updateRuneSlots);
         this.runeCombinerViewController.getCombineFailed().add(this.updateRuneSlots);
         this.runeCombinerViewController.getCombineSucceeded().add(this.onCombineSucceeded);
      }
      
      private function onRuneCombinerViewActiveChanged(param1:Boolean) : void
      {
         if(param1 == false)
         {
            this.runeCombinerViewController.removeAllRunesFromCombiner();
            this.updateRuneSlots();
         }
      }
      
      private function handleCombinerMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:String = "";
         if(this.runeCombinerViewController.getRunesToCombine().getLength() == 2)
         {
            _loc2_ = this.rM.getString("resources","runeCombiner_CombineButton_TwoTooltip");
         }
         else if(this.runeCombinerViewController.getRunesToCombine().getLength() == 5)
         {
            _loc2_ = this.rM.getString("resources","runeCombiner_CombineButton_FiveTooltip");
         }
         if(_loc2_ != "")
         {
            this._toolTipManager.assignToolTip(this.combineButton,_loc2_);
         }
      }
      
      private function handleCombinerMouseOut(param1:MouseEvent) : void
      {
         this._toolTipManager.unassignToolTip(this.combineButton);
      }
      
      private function onCombineSucceeded(param1:IListX) : void
      {
         this.updateRuneSlots();
         this._showingReward = true;
         this.rewardRenderer.setAlpha(100);
         this._soundProvider.play(AudioKeys.RUNES_COMBINE_RUNES);
         setCurrentState("reward");
         var _loc2_:SummonerRune = param1.getItemAt(0) as SummonerRune;
         this.rewardRenderer.setRune(_loc2_.rune);
         this.rewardTweenFadeTimer.reset();
         this.rewardTweenFadeTimer.start();
      }
      
      private function onRewardTweenFadeTimerComplete(param1:TimerEvent) : void
      {
         TweenLite.to(this.rewardRenderer.getSetterProxy(),2,{"alpha":0});
         this.postRewardResetTimer.reset();
         this.postRewardResetTimer.start();
      }
      
      private function onPostRewardResetTimerComplete(param1:TimerEvent) : void
      {
         this._showingReward = false;
         if(this.runeCombinerViewController.getRunesToCombine().getLength() == 0)
         {
            this.disableCombine();
         }
      }
      
      private function onCombineButtonClicked(param1:MouseEvent) : void
      {
         this._runesTracker.incrementRunes_CombinerCombines_Count_InASession();
         this._toolTipManager.unassignToolTip(this);
         this.runeCombinerViewController.combine();
      }
      
      private function updateStateByRunesInCombiner(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               if(!this._showingReward)
               {
                  this.disableCombine();
               }
               break;
            case 2:
               this.activateTwoRunesState();
               break;
            case 5:
               this.activateFiveRunesState();
               break;
            default:
               this.disableCombine();
         }
      }
      
      private function disableCombine() : void
      {
         setCurrentState("inactive");
         this.combineButton.setEnabled(false);
         this.combineButton.setText("");
         this.rewardRenderer.setRune(null);
      }
      
      private function activateFiveRunesState() : void
      {
         setCurrentState("fiveRunesCombine");
         this.combineButton.setEnabled(true);
         this.combineButton.setText(this.rM.getString("resources","runeCombiner_CombineButton",[5]));
      }
      
      private function activateTwoRunesState() : void
      {
         setCurrentState("twoRunesCombine");
         this.combineButton.setEnabled(true);
         this.combineButton.setText(this.rM.getString("resources","runeCombiner_CombineButton",[2]));
      }
      
      private function updateRuneSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Rune = null;
         var _loc3_:RuneCombinerSlotView = null;
         var _loc4_:IListX = this.runeCombinerViewController.getRunesToCombine();
         var _loc5_:uint = uint(_loc4_.getLength());
         if(this._showingReward)
         {
            this._showingReward = false;
            this.disableCombine();
            TweenLite.killTweensOf(this.rewardRenderer.getSetterProxy());
            this.rewardTweenFadeTimer.stop();
            this.postRewardResetTimer.stop();
         }
         this.playSoundByIndex(_loc5_);
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc2_ = _loc4_.getItemAt(_loc1_) as Rune;
            _loc3_ = this.runeSlots[_loc1_];
            _loc3_.setCurrentState("filled");
            _loc3_.setData(_loc2_);
            _loc1_++;
         }
         _loc1_ = int(_loc5_);
         while(_loc1_ < this.runeSlots.length)
         {
            _loc2_ = null;
            _loc3_ = this.runeSlots[_loc1_];
            _loc3_.setCurrentState("inactive");
            _loc3_.setData(_loc2_);
            _loc1_++;
         }
         if(this.runeCombinerViewController.canAddMoreRunes())
         {
            _loc3_ = this.runeSlots[_loc5_];
            _loc3_.setCurrentState("active");
         }
         this.updateStateByRunesInCombiner(_loc5_);
      }
      
      private function playSoundByIndex(param1:uint) : void
      {
         switch(param1)
         {
            case 1:
               this._soundProvider.play(AudioKeys.RUNES_RUNE_DROP_3);
               break;
            case 2:
               this._soundProvider.play(AudioKeys.RUNES_RUNE_DROP_4);
               break;
            case 3:
               this._soundProvider.play(AudioKeys.RUNES_RUNE_DROP_5);
               break;
            case 4:
               this._soundProvider.play(AudioKeys.RUNES_RUNE_DROP_6);
               break;
            case 5:
               this._soundProvider.play(AudioKeys.RUNES_RUNE_DROP_7);
         }
      }
      
      override public function destroy() : void
      {
         this.runeCombinerViewController.getRuneAddedToCombiner().remove(this.updateRuneSlots);
         this.runeCombinerViewController.getRuneRemovedFromCombiner().remove(this.updateRuneSlots);
         this.runeCombinerViewController.getCombineFailed().remove(this.updateRuneSlots);
         this.runeCombinerViewController.getCombineSucceeded().remove(this.onCombineSucceeded);
         super.destroy();
      }
   }
}

