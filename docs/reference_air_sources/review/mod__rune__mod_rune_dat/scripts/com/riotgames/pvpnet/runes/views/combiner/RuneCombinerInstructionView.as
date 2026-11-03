package com.riotgames.pvpnet.runes.views.combiner
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.IListX;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneCombinerViewController;
   import com.riotgames.pvpnet.runes.views.common.RuneImageRenderer;
   import com.riotgames.pvpnet.runes.views.runespage.RuneItemEffectRenderer;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RuneCombinerInstructionView extends StatefulView
   {
      
      private var headerText:TextFieldProxy;
      
      private var instructionText:TextFieldProxy;
      
      private var rewardImageSizer:SpriteProxy;
      
      private var rewardImageRenderer:RuneImageRenderer;
      
      private var rewardNameTextField:TextFieldProxy;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      private var rM:IResourceManager = ResourceManager.getInstance();
      
      private var itemEffectRenderer:RuneItemEffectRenderer;
      
      public function RuneCombinerInstructionView(param1:IContext)
      {
         super(param1);
         setCurrentState("instructions");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.headerText = new TextFieldProxy(this);
         setTimelineChildByName("runeCombinerHeaderLabel",this.headerText);
         this.headerText.setText(this.rM.getString("resources","runeCombiner_instructionsHeaderLabel"));
         this.instructionText = new TextFieldProxy(this);
         setTimelineChildByName("runeCombinerInstructionsLabel",this.instructionText);
         this.instructionText.setText(this.getRuneCombinerInstructionText());
         var _loc1_:TextFieldProxy = new TextFieldProxy(this);
         _loc1_.setText(this.rM.getString("resources","runebook_book_statsHeaderLabel"));
         setTimelineChildByName("rewardHeader.textField",_loc1_);
         this.rewardImageSizer = new SpriteProxy(this);
         setTimelineChildByName("rewardImageSizer",this.rewardImageSizer);
         this.rewardImageSizer.getLayoutInvalidated().add(invalidateLayout);
         this.rewardImageRenderer = new RuneImageRenderer(this);
         setTimelineChildByName("rewardImageRenderer",this.rewardImageRenderer);
         this.rewardImageRenderer.setRuneEffectGlowActive(false);
         this.rewardImageRenderer.setSizer(this.rewardImageSizer);
         this.rewardNameTextField = new TextFieldProxy(this);
         setTimelineChildByName("rewardNameTextField",this.rewardNameTextField);
         this.rewardNameTextField.setAutoSize(TextFieldAutoSize.CENTER);
         this.itemEffectRenderer = new RuneItemEffectRenderer(this);
         setTimelineChildByName("itemEffectRenderer",this.itemEffectRenderer);
         this.runeCombinerViewController.getCombineStarted().add(this.onCombineStarted);
         this.runeCombinerViewController.getCombineFailed().add(this.onCombinerContentsChanged);
         this.runeCombinerViewController.getCombineSucceeded().add(this.onCombineSucceeded);
         this.runeCombinerViewController.getRuneCombinerViewActiveChanged().add(this.onRuneCombinerActiveChanged);
      }
      
      private function onCombineStarted() : void
      {
         this.instructionText.setText(this.rM.getString("resources","runeCombiner_instructions_melting"));
      }
      
      private function onCombineSucceeded(param1:IListX) : void
      {
         var _loc2_:SummonerRune = param1.getItemAt(0) as SummonerRune;
         var _loc3_:Rune = _loc2_.rune;
         setCurrentState("results");
         this.headerText.setText("");
         this.instructionText.setText(this.rM.getString("resources","runeCombiner_instructions_congratulations"));
         if(_loc3_)
         {
            this.rewardNameTextField.setText(_loc3_.displayName);
            this.rewardImageRenderer.setRune(_loc3_);
            this.itemEffectRenderer.setData(_loc3_.itemEffects.getItemAt(0));
         }
      }
      
      private function onRuneCombinerActiveChanged(param1:Boolean) : void
      {
         if(param1)
         {
            setCurrentState("instructions");
         }
      }
      
      private function onCombinerContentsChanged() : void
      {
         this.instructionText.setText(this.getRuneCombinerInstructionText());
      }
      
      public function getRuneCombinerInstructionText() : String
      {
         var _loc2_:String = null;
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:uint = uint(this.runeCombinerViewController.getRunesToCombine().getLength());
         switch(_loc3_)
         {
            case 0:
            case 1:
               _loc2_ = _loc1_.getString("resources","runeCombiner_instructions_0");
               break;
            case 2:
               if(this.runeCombinerViewController.canAddMoreRunes())
               {
                  _loc2_ = _loc1_.getString("resources","runeCombiner_instructions_2");
               }
               else
               {
                  _loc2_ = _loc1_.getString("resources","runeCombiner_instructions_1");
               }
               break;
            case 3:
            case 4:
               _loc2_ = _loc1_.getString("resources","runeCombiner_instructions_3");
               break;
            case 5:
               _loc2_ = _loc1_.getString("resources","runeCombiner_instructions_5");
         }
         return _loc2_;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runeCombinerViewController = getDependency(RuneCombinerViewController);
      }
      
      override public function destroy() : void
      {
         this.runeCombinerViewController.getCombineStarted().remove(this.onCombineStarted);
         this.runeCombinerViewController.getCombineFailed().remove(this.onCombinerContentsChanged);
         this.runeCombinerViewController.getCombineSucceeded().remove(this.onCombineSucceeded);
         this.runeCombinerViewController.getRuneCombinerViewActiveChanged().remove(this.onRuneCombinerActiveChanged);
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.rewardImageRenderer.setExplicitSize(this.rewardImageSizer.getWidth(),this.rewardImageSizer.getHeight());
         return super.updateLayout(param1,param2);
      }
   }
}

