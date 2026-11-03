package org.papervision3d.scenes
{
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class MovieScene3D extends Scene3D
   {
      
      private var spriteList:Dictionary;
      
      private var containerList:Array;
      
      public function MovieScene3D(container:Sprite, interactive:Boolean = false)
      {
         super(container,interactive);
         this.containerList = new Array();
         spriteList = new Dictionary();
      }
      
      override public function addChild(child:DisplayObject3D, name:String = null) : DisplayObject3D
      {
         child = super.addChild(child,name);
         child.container = new Sprite();
         container.addChild(child.container);
         this.containerList.push(child.container);
         spriteList[child] = child.container;
         return child;
      }
      
      override protected function renderObjects(camera:CameraObject3D) : void
      {
         var objectsLength:Number = NaN;
         var gfx:Sprite = null;
         var containerList:Array = null;
         var i:Number = NaN;
         var p:DisplayObject3D = null;
         var objects:Array = null;
         objectsLength = this.objects.length;
         containerList = this.containerList;
         for(i = 0; Boolean(gfx = containerList[i++]); )
         {
            gfx.graphics.clear();
         }
         this.stats = renderer.render(this,container,camera);
         stats.performance = getTimer() - stats.performance;
         objects = this.objects;
         i = objects.length;
         if(camera.sort)
         {
            while(Boolean(p = objects[--i]))
            {
               if(p.visible)
               {
                  container.addChild(p.container);
               }
            }
         }
      }
      
      public function getSprite(child:DisplayObject3D) : Sprite
      {
         return spriteList[child];
      }
      
      override public function removeChild(child:DisplayObject3D) : DisplayObject3D
      {
         var removed:DisplayObject3D = null;
         var i:int = 0;
         removed = super.removeChild(child);
         for(i = 0; i < containerList.length; i++)
         {
            if(removed.container == containerList[i])
            {
               this.containerList.splice(i,1);
            }
         }
         container.removeChild(removed.container);
         delete spriteList[removed];
         return removed;
      }
   }
}

