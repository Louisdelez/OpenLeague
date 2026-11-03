package org.papervision3d.materials
{
   import flash.display.Graphics;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   
   public class WireframeMaterial extends TriangleMaterial implements ITriangleDrawer
   {
      
      public function WireframeMaterial(color:Number = 16711935, alpha:Number = 100)
      {
         super();
         this.lineColor = color;
         this.lineAlpha = alpha;
         this.doubleSided = false;
      }
      
      override public function toString() : String
      {
         return "WireframeMaterial - color:" + this.lineColor + " alpha:" + this.lineAlpha;
      }
      
      override public function drawTriangle(face3D:Triangle3D, graphics:Graphics, renderSessionData:RenderSessionData) : void
      {
         var x0:Number = NaN;
         var y0:Number = NaN;
         x0 = face3D.v0.vertex3DInstance.x;
         y0 = face3D.v0.vertex3DInstance.y;
         if(Boolean(lineAlpha))
         {
            graphics.lineStyle(0,lineColor,lineAlpha);
            graphics.moveTo(x0,y0);
            graphics.lineTo(face3D.v1.vertex3DInstance.x,face3D.v1.vertex3DInstance.y);
            graphics.lineTo(face3D.v2.vertex3DInstance.x,face3D.v2.vertex3DInstance.y);
            graphics.lineTo(x0,y0);
            graphics.lineStyle();
            ++renderSessionData.renderStatistics.triangles;
         }
      }
   }
}

