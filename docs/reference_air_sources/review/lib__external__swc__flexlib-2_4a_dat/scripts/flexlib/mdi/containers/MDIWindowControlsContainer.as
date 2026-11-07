package flexlib.mdi.containers
{
   import flash.display.DisplayObject;
   import mx.controls.Button;
   import mx.core.ContainerLayout;
   import mx.core.LayoutContainer;
   import mx.core.UITextField;
   
   public class MDIWindowControlsContainer extends LayoutContainer
   {
      
      public var maximizeRestoreBtn:Button;
      
      public var closeBtn:Button;
      
      public var minimizeBtn:Button;
      
      public var window:MDIWindow;
      
      public function MDIWindowControlsContainer()
      {
         super();
         layout = ContainerLayout.HORIZONTAL;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!minimizeBtn)
         {
            minimizeBtn = new Button();
            minimizeBtn.buttonMode = true;
            addChild(minimizeBtn);
         }
         if(!maximizeRestoreBtn)
         {
            maximizeRestoreBtn = new Button();
            maximizeRestoreBtn.buttonMode = true;
            addChild(maximizeRestoreBtn);
         }
         if(!closeBtn)
         {
            closeBtn = new Button();
            closeBtn.buttonMode = true;
            addChild(closeBtn);
         }
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var minX:Number = NaN;
         var minY:Number = NaN;
         var maxX:Number = NaN;
         var maxY:Number = NaN;
         var child:DisplayObject = null;
         var tf:UITextField = null;
         var icon:DisplayObject = null;
         super.updateDisplayList(w,h);
         minX = 9999;
         minY = 9999;
         maxX = -9999;
         maxY = -9999;
         for each(child in this.getChildren())
         {
            minX = Math.min(minX,child.x);
            minY = Math.min(minY,child.y);
            maxX = Math.max(maxX,child.x + child.width);
            maxY = Math.max(maxY,child.y + child.height);
         }
         this.setActualSize(maxX - minX,maxY - minY);
         this.x = window.width - this.width - Number(window.getStyle("borderThicknessRight"));
         this.y = (window.titleBarOverlay.height - this.height) / 2;
         tf = window.getTitleTextField();
         icon = window.getTitleIconObject();
         tf.x = Number(window.getStyle("borderThicknessLeft"));
         if(Boolean(icon))
         {
            icon.x = tf.x;
            tf.x = icon.x + icon.width + 4;
         }
         if(!window.minimized)
         {
            tf.width = this.x - tf.x;
         }
         else
         {
            tf.width = window.width - tf.x - 4;
         }
      }
   }
}

