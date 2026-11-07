package com.riotgames.pvpnet.runes.views.combiner
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   
   public class RuneCombinerView extends StatefulView
   {
      
      private var combinerCircle:RuneCombinerCircleView;
      
      private var instructionView:RuneCombinerInstructionView;
      
      public function RuneCombinerView(param1:IContext)
      {
         super(param1);
         setLinkage("RuneCombiner");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.combinerCircle = new RuneCombinerCircleView(this);
         setTimelineChildByName("combinerCircle",this.combinerCircle);
         this.instructionView = new RuneCombinerInstructionView(this);
         setTimelineChildByName("instructionBlock",this.instructionView);
      }
   }
}

