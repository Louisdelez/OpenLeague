package org.papervision3d.events
{
   import flash.display.Sprite;
   import flash.events.Event;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class InteractiveScene3DEvent extends Event
   {
      
      public static const OBJECT_CLICK:String = "mouseClick";
      
      public static const OBJECT_OVER:String = "mouseOver";
      
      public static const OBJECT_OUT:String = "mouseOut";
      
      public static const OBJECT_MOVE:String = "mouseMove";
      
      public static const OBJECT_PRESS:String = "mousePress";
      
      public static const OBJECT_RELEASE:String = "mouseRelease";
      
      public static const OBJECT_RELEASE_OUTSIDE:String = "mouseReleaseOutside";
      
      public static const OBJECT_ADDED:String = "objectAdded";
      
      public var sprite:Sprite = null;
      
      public var displayObject3D:DisplayObject3D = null;
      
      public var face3d:Triangle3D = null;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public function InteractiveScene3DEvent(type:String, container3d:DisplayObject3D = null, sprite:Sprite = null, face3d:Triangle3D = null, x:Number = 0, y:Number = 0, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.displayObject3D = container3d;
         this.sprite = sprite;
         this.face3d = face3d;
         this.x = x;
         this.y = y;
      }
   }
}

