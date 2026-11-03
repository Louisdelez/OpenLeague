package com.riotgames.rust.components.button
{
   import blix.components.button.ButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   
   public class NotificationCountButton extends ButtonX
   {
      
      private var counter:StatefulView;
      
      private var countLabel:Text;
      
      private var _count:uint = 0;
      
      public function NotificationCountButton(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this.counter = new StatefulView(this);
         setTimelineChildByName("counter",this.counter);
         this.counter.setCurrentState("hide");
         this.countLabel = new Text(this);
         this.counter.setTimelineChildByName("countLabel",this.countLabel);
      }
      
      public function setCount(param1:uint) : void
      {
         if(param1 != this._count)
         {
            this._count = param1;
            this.updateState();
         }
      }
      
      public function getCount() : uint
      {
         return this._count;
      }
      
      private function updateState() : void
      {
         if(this._count == 0)
         {
            this.counter.setCurrentState("hide");
         }
         else
         {
            this.counter.setCurrentState("show");
         }
         this.countLabel.setText(this._count.toString());
      }
   }
}

