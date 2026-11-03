package com.dougmccune.containers
{
   import caurina.transitions.Tweener;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CoverFlowContainer extends BasePV3DContainer
   {
      
      protected var maxChildWidth:Number;
      
      public var rotationAngle:Number = 70;
      
      public var fadeEdges:Boolean = false;
      
      protected var maxChildHeight:Number;
      
      public function CoverFlowContainer()
      {
         super();
      }
      
      override protected function layoutChildren(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.layoutChildren(unscaledWidth,unscaledHeight);
         layoutCoverflow(unscaledWidth,unscaledHeight);
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         super.addChild(child);
         var childHeight:Number = child is UIComponent ? Number(UIComponent(child).getExplicitOrMeasuredHeight()) : child.height;
         if(isNaN(maxChildHeight) || childHeight > maxChildHeight)
         {
            maxChildHeight = childHeight;
         }
         return child;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         return super.removeChild(child);
      }
      
      protected function layoutCoverflow(uncaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:DisplayObject = null;
         var plane:DisplayObject3D = null;
         var abs:Number = NaN;
         var horizontalGap:Number = NaN;
         var verticalGap:Number = NaN;
         var xPosition:Number = NaN;
         var yPosition:Number = NaN;
         var zPosition:Number = NaN;
         var yRotation:Number = NaN;
         var alpha:Number = NaN;
         var colorTransform:ColorTransform = null;
         var reflection:DisplayObject3D = null;
         var bm:EdgeMetrics = null;
         var n:int = int(numChildren);
         for(var i:int = 0; i < n; i++)
         {
            child = getChildAt(i);
            plane = lookupPlane(child);
            if(plane != null)
            {
               plane.container.visible = true;
               abs = Math.abs(selectedIndex - i);
               horizontalGap = Number(getStyle("horizontalSpacing"));
               if(isNaN(horizontalGap))
               {
                  horizontalGap = maxChildHeight / 3;
               }
               verticalGap = Number(getStyle("verticalSpacing"));
               if(isNaN(verticalGap))
               {
                  verticalGap = 10;
               }
               xPosition = selectedChild.width + (abs - 1) * horizontalGap;
               yPosition = -(maxChildHeight - child.height) / 2;
               zPosition = camera.z / 2 + selectedChild.width + abs * verticalGap;
               yRotation = rotationAngle;
               alpha = (unscaledWidth / 2 - xPosition) / (unscaledWidth / 2);
               alpha = Math.max(Math.min(alpha * 2,1),0);
               if(i < selectedIndex)
               {
                  xPosition *= -1;
                  yRotation *= -1;
               }
               else if(i == selectedIndex)
               {
                  xPosition = 0;
                  zPosition = camera.z / 2;
                  yRotation = 0;
                  alpha = 1;
               }
               if(fadeEdges)
               {
                  colorTransform = child.transform.colorTransform;
                  colorTransform.alphaMultiplier = alpha;
                  child.transform.colorTransform = colorTransform;
                  plane.material.updateBitmap();
               }
               if(reflectionEnabled)
               {
                  reflection = lookupReflection(child);
                  if(fadeEdges)
                  {
                     reflection.material.updateBitmap();
                  }
                  reflection.y = yPosition - child.height - 2;
                  if(i != selectedIndex)
                  {
                     Tweener.addTween(reflection,{
                        "z":zPosition,
                        "time":tweenDuration / 3
                     });
                     Tweener.addTween(reflection,{
                        "x":xPosition,
                        "rotationY":yRotation,
                        "time":tweenDuration
                     });
                  }
                  else
                  {
                     Tweener.addTween(reflection,{
                        "x":xPosition,
                        "z":zPosition,
                        "rotationY":yRotation,
                        "time":tweenDuration
                     });
                  }
               }
               if(i != selectedIndex)
               {
                  Tweener.addTween(plane,{
                     "z":zPosition,
                     "time":tweenDuration / 3
                  });
                  Tweener.addTween(plane,{
                     "x":xPosition,
                     "y":yPosition,
                     "rotationY":yRotation,
                     "time":tweenDuration
                  });
               }
               else
               {
                  Tweener.addTween(plane,{
                     "x":xPosition,
                     "y":yPosition,
                     "z":zPosition,
                     "rotationY":yRotation,
                     "time":tweenDuration
                  });
               }
               if(i == selectedIndex)
               {
                  bm = borderMetrics;
                  child.x = unscaledWidth / 2 - child.width / 2 - bm.top;
                  child.y = unscaledHeight / 2 - child.height / 2 - yPosition - bm.left;
                  child.visible = false;
               }
            }
         }
      }
   }
}

