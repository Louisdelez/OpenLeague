package org.papervision3d.core.render.command
{
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.IRenderable;
   import org.papervision3d.core.render.hit.RenderHitData;
   
   public class RenderableListItem extends AbstractRenderListItem
   {
      
      public var renderableInstance:IRenderable;
      
      public var renderable:Class;
      
      public function RenderableListItem()
      {
         super();
      }
      
      public function hitTestPoint2D(point:Point, renderHitData:RenderHitData) : RenderHitData
      {
         return renderHitData;
      }
   }
}

