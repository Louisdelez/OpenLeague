package org.papervision3d.core.geom.renderables
{
   import org.papervision3d.core.geom.Particles;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderParticle;
   import org.papervision3d.materials.ParticleMaterial;
   
   public class Particle implements IRenderable
   {
      
      public var size:int;
      
      public var renderCommand:RenderParticle;
      
      public var renderScale:Number;
      
      public var instance:Particles;
      
      public var material:ParticleMaterial;
      
      public var vertex3D:Vertex3D;
      
      public function Particle(material:ParticleMaterial, size:int = 1, x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.material = material;
         this.size = size;
         this.renderCommand = new RenderParticle(this);
         vertex3D = new Vertex3D(x,y,z);
      }
      
      public function get y() : Number
      {
         return vertex3D.y;
      }
      
      public function set x(x:Number) : void
      {
         vertex3D.x = x;
      }
      
      public function set y(y:Number) : void
      {
         vertex3D.y = y;
      }
      
      public function get x() : Number
      {
         return vertex3D.x;
      }
      
      public function get z() : Number
      {
         return vertex3D.z;
      }
      
      public function set z(z:Number) : void
      {
         vertex3D.z = z;
      }
      
      public function getRenderListItem() : IRenderListItem
      {
         return renderCommand;
      }
   }
}

