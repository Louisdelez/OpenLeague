package org.papervision3d.core.render.draw
{
   import flash.display.Graphics;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public interface ITriangleDrawer
   {
      
      function drawTriangle(param1:Triangle3D, param2:Graphics, param3:RenderSessionData) : void;
   }
}

