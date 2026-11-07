package spark.components.supportClasses
{
   import flash.geom.PerspectiveProjection;
   import flash.geom.Rectangle;
   import mx.core.IFactory;
   import mx.core.IVisualElement;
   import mx.utils.MatrixUtil;
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.IItemRenderer;
   import spark.components.List;
   
   public class ListItemDragProxy extends Group
   {
      
      private static var elementBounds:Rectangle;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ListItemDragProxy()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var element:IVisualElement = null;
         var clone:IItemRenderer = null;
         var elementBounds:Rectangle = null;
         super.createChildren();
         var list:List = owner as List;
         if(!list)
         {
            return;
         }
         var dataGroup:DataGroup = list.dataGroup;
         if(!dataGroup)
         {
            return;
         }
         this.styleName = list;
         width = dataGroup.width;
         height = dataGroup.height;
         var selection:Vector.<int> = list.selectedIndices;
         if(!selection)
         {
            return;
         }
         var offsetX:Number = 0;
         var offsetY:Number = 0;
         var scrollRect:Rectangle = dataGroup.scrollRect;
         if(Boolean(scrollRect))
         {
            offsetX = scrollRect.x;
            offsetY = scrollRect.y;
         }
         var perspectiveProjection:PerspectiveProjection = dataGroup.transform.perspectiveProjection;
         var elementsIn3D:Boolean = false;
         var count:int = int(selection.length);
         for(var i:int = 0; i < count; i++)
         {
            element = dataGroup.getElementAt(selection[i]);
            if(!(!element || !(element is IItemRenderer)))
            {
               if(element.is3D)
               {
                  elementsIn3D = true;
               }
               if(Boolean(scrollRect))
               {
                  if(element.hasLayoutMatrix3D)
                  {
                     elementBounds = new Rectangle(0,0,element.getLayoutBoundsWidth(false),element.getLayoutBoundsHeight(false));
                     elementBounds = MatrixUtil.projectBounds(elementBounds,element.getLayoutMatrix3D(),perspectiveProjection);
                  }
                  else
                  {
                     elementBounds = this.getElementBounds(element);
                  }
                  if(!scrollRect.containsRect(elementBounds) && !scrollRect.intersects(elementBounds))
                  {
                     continue;
                  }
               }
               clone = this.cloneItemRenderer(IItemRenderer(element),list);
               clone.width = element.width;
               clone.height = element.height;
               if(element.hasLayoutMatrix3D)
               {
                  clone.setLayoutMatrix3D(element.getLayoutMatrix3D(),false);
               }
               else
               {
                  clone.setLayoutMatrix(element.getLayoutMatrix(),false);
               }
               clone.x -= offsetX;
               clone.y -= offsetY;
               clone.depth = element.depth;
               clone.visible = element.visible;
               if(Boolean(element.postLayoutTransformOffsets))
               {
                  clone.postLayoutTransformOffsets = element.postLayoutTransformOffsets;
               }
               clone.dragging = true;
               addElement(clone);
            }
         }
         if(elementsIn3D)
         {
            this.transform.perspectiveProjection = perspectiveProjection;
         }
      }
      
      private function getElementBounds(element:IVisualElement) : Rectangle
      {
         if(!elementBounds)
         {
            elementBounds = new Rectangle();
         }
         elementBounds.x = element.getLayoutBoundsX();
         elementBounds.y = element.getLayoutBoundsY();
         elementBounds.width = element.getLayoutBoundsWidth();
         elementBounds.height = element.getLayoutBoundsHeight();
         return elementBounds;
      }
      
      private function cloneItemRenderer(renderer:IItemRenderer, list:List) : IItemRenderer
      {
         var rendererFactory:IFactory = null;
         var itemRendererFunction:Function = list.itemRendererFunction;
         var data:Object = renderer.data;
         if(itemRendererFunction != null)
         {
            rendererFactory = itemRendererFunction(data);
         }
         if(!rendererFactory)
         {
            rendererFactory = list.itemRenderer;
         }
         var newRenderer:IItemRenderer = rendererFactory.newInstance();
         if(!newRenderer)
         {
            return null;
         }
         list.updateRenderer(newRenderer,renderer.itemIndex,data);
         return newRenderer;
      }
   }
}

