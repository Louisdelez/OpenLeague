package com.dougmccune.containers
{
   import caurina.transitions.Tweener;
   import com.dougmccune.containers.materials.FlexMaterial;
   import com.dougmccune.containers.materials.ReflectionFlexMaterial;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import mx.containers.ViewStack;
   import mx.core.ContainerCreationPolicy;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.core.culling.RectangleTriangleCuller;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.Plane;
   import org.papervision3d.scenes.MovieScene3D;
   import org.papervision3d.scenes.Scene3D;
   
   [Style(name="verticalSpacing",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalSpacing",type="Number",format="Length",inherit="no")]
   public class BasePV3DContainer extends ViewStack
   {
      
      private var timer:Timer;
      
      protected var scene:Scene3D;
      
      private var clippingMask:Sprite;
      
      private var _reflectionEnabled:Boolean = false;
      
      public var tweenDuration:Number = 1;
      
      public var segments:Number = 6;
      
      protected var camera:CameraObject3D;
      
      private var objectsToPlanes:Dictionary;
      
      private var containersToObjects:Dictionary;
      
      private var objectsToReflections:Dictionary;
      
      public var autoUpdateFlexMaterials:Boolean = false;
      
      private var pv3dSprite:Sprite;
      
      public function BasePV3DContainer()
      {
         super();
         this.creationPolicy = ContainerCreationPolicy.ALL;
         objectsToPlanes = new Dictionary(true);
         objectsToReflections = new Dictionary(true);
         containersToObjects = new Dictionary(true);
         timer = new Timer(tweenDuration * 1000,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
         pv3dSprite = new Sprite();
         setupScene();
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         child = super.addChild(child);
         if(child.width > 0 && child.height > 0)
         {
            createPlaneForChild(child);
         }
         if(child is UIComponent && autoUpdateFlexMaterials)
         {
            UIComponent(child).addEventListener(FlexEvent.UPDATE_COMPLETE,child_renderHandler);
         }
         return child;
      }
      
      private function createPlane(child:DisplayObject) : Plane
      {
         var reflMaterial:MovieMaterial = null;
         var reflection:Plane = null;
         var childWidth:Number = child is UIComponent ? Number(UIComponent(child).getExplicitOrMeasuredWidth()) : child.width;
         var childHeight:Number = child is UIComponent ? Number(UIComponent(child).getExplicitOrMeasuredHeight()) : child.height;
         if(reflectionEnabled)
         {
            reflMaterial = new ReflectionFlexMaterial(child);
            reflection = new Plane(reflMaterial,childWidth,childHeight,segments,segments);
            scene.addChild(reflection);
            objectsToReflections[child] = reflection;
         }
         child.width = childWidth;
         child.height = childHeight;
         var material:MovieMaterial = new FlexMaterial(child,true);
         material.smooth = true;
         return new Plane(material,childWidth,childHeight,segments,segments);
      }
      
      protected function destroyPlane(child:DisplayObject) : void
      {
         var plane:DisplayObject3D = lookupPlane(child);
         if(Boolean(plane))
         {
            plane.material.bitmap.dispose();
            plane.material.bitmap = null;
            objectsToPlanes[child] = null;
            containersToObjects[plane.container] = null;
            plane.geometry.vertices = null;
            plane.faces = null;
            scene.removeChild(plane);
         }
         destroyReflection(child);
      }
      
      protected function lookupReflection(child:DisplayObject) : DisplayObject3D
      {
         return objectsToReflections[child];
      }
      
      protected function setupScene() : void
      {
         Papervision3D.VERBOSE = false;
         scene = new MovieScene3D(pv3dSprite);
         scene.triangleCuller = new RectangleTriangleCuller();
         camera = new Camera3D();
         camera.z = -200;
      }
      
      protected function destroyReflection(child:DisplayObject) : void
      {
         var reflection:DisplayObject3D = lookupReflection(child);
         if(Boolean(reflection))
         {
            reflection.material.bitmap.dispose();
            reflection.material.bitmap = null;
            objectsToReflections[child] = null;
            reflection.geometry.vertices = null;
            reflection.faces = null;
            scene.removeChild(reflection);
         }
      }
      
      public function get reflectionEnabled() : Boolean
      {
         return _reflectionEnabled;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         clippingMask = new Sprite();
         rawChildren.addChild(clippingMask);
         rawChildren.addChildAt(pv3dSprite,0);
         this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
      }
      
      private function timerComplete(event:TimerEvent) : void
      {
         showVisibleChild();
      }
      
      protected function layoutChildren(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(timer.running)
         {
            timer.reset();
         }
         timer.start();
      }
      
      override public function removeAllChildren() : void
      {
         super.removeAllChildren();
         objectsToPlanes = new Dictionary(true);
         objectsToReflections = new Dictionary(true);
         containersToObjects = new Dictionary(true);
      }
      
      protected function enterFrameHandler(event:Event) : void
      {
         var plane:Plane = null;
         try
         {
            if(selectedChild != null)
            {
               plane = objectsToPlanes[selectedChild];
               if(Tweener.isTweening(plane))
               {
                  scene.renderCamera(camera);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function showVisibleChild() : void
      {
         var plane:DisplayObject3D = null;
         if(selectedChild != null)
         {
            selectedChild.visible = true;
            plane = lookupPlane(selectedChild);
            if(Boolean(plane))
            {
               plane.container.visible = false;
            }
            if(Boolean(border))
            {
               rawChildren.setChildIndex(pv3dSprite,0);
               rawChildren.setChildIndex(DisplayObject(border),0);
            }
            else
            {
               rawChildren.setChildIndex(pv3dSprite,0);
            }
         }
      }
      
      public function set reflectionEnabled(value:Boolean) : void
      {
         _reflectionEnabled = value;
      }
      
      private function containerClicked(event:MouseEvent) : void
      {
         var child:DisplayObject = containersToObjects[event.currentTarget];
         var index:int = int(getChildIndex(child));
         selectedIndex = index;
      }
      
      protected function lookupPlane(child:DisplayObject) : DisplayObject3D
      {
         return objectsToPlanes[child];
      }
      
      private function child_renderHandler(event:Event) : void
      {
         var child:UIComponent = event.currentTarget as UIComponent;
         var plane:Plane = lookupPlane(child) as Plane;
         var material:BitmapMaterial = Boolean(plane) ? plane.material as BitmapMaterial : null;
         var childWidth:Number = child is UIComponent ? Number(UIComponent(child).getExplicitOrMeasuredWidth()) : Number(child.width);
         var childHeight:Number = child is UIComponent ? Number(UIComponent(child).getExplicitOrMeasuredHeight()) : Number(child.height);
         childWidth = Math.round(childWidth);
         childHeight = Math.round(childHeight);
         if(material == null || material.bitmap.width != childWidth || material.bitmap.height != childHeight)
         {
            if(childWidth > 0 && childHeight > 0)
            {
               replacePlaneForChild(child);
            }
         }
         else
         {
            plane.material.updateBitmap();
         }
         layoutChildren(width,height);
      }
      
      private function replacePlaneForChild(child:DisplayObject) : void
      {
         var oldPlane:Plane = lookupPlane(child) as Plane;
         var oldX:Number = oldPlane.x;
         var oldY:Number = oldPlane.y;
         var oldZ:Number = oldPlane.z;
         var oldRotationX:Number = oldPlane.rotationX;
         var oldRotationY:Number = oldPlane.rotationY;
         var oldRotationZ:Number = oldPlane.rotationZ;
         destroyPlane(child);
         var plane:Plane = createPlane(child);
         plane.x = oldX;
         plane.y = oldY;
         plane.z = oldZ;
         plane.rotationX = oldRotationX;
         plane.rotationY = oldRotationY;
         plane.rotationZ = oldRotationZ;
         scene.addChild(plane);
         containersToObjects[plane.container] = child;
         plane.container.addEventListener(MouseEvent.CLICK,containerClicked);
         objectsToPlanes[child] = plane;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(rawChildren.contains(pv3dSprite))
         {
            if(Boolean(border))
            {
               rawChildren.setChildIndex(pv3dSprite,0);
               rawChildren.setChildIndex(DisplayObject(border),0);
            }
            else
            {
               rawChildren.setChildIndex(pv3dSprite,0);
            }
         }
         clippingMask.graphics.clear();
         if(clipContent)
         {
            clippingMask.graphics.beginFill(0);
            clippingMask.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
            pv3dSprite.mask = clippingMask;
         }
         pv3dSprite.y = unscaledHeight / 2;
         pv3dSprite.x = unscaledWidth / 2;
         if(scene.triangleCuller is RectangleTriangleCuller)
         {
            (scene.triangleCuller as RectangleTriangleCuller).cullingRectangle = new Rectangle(-unscaledWidth / 2,-unscaledHeight / 2,unscaledWidth,unscaledHeight);
         }
         layoutChildren(unscaledWidth,unscaledHeight);
      }
      
      protected function createPlaneForChild(child:DisplayObject) : void
      {
         var plane:Plane = createPlane(child);
         scene.addChild(plane);
         containersToObjects[plane.container] = child;
         plane.container.addEventListener(MouseEvent.CLICK,containerClicked);
         objectsToPlanes[child] = plane;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         child = super.removeChild(child);
         destroyPlane(child);
         return child;
      }
   }
}

