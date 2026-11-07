package org.papervision3d.core.geom
{
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Particles extends Vertices3D
   {
      
      private var particles:Array = new Array();
      
      private var vertices:Array = new Array();
      
      public function Particles(name:String = "VertexParticles")
      {
         super(vertices,name);
      }
      
      override public function project(parent:DisplayObject3D, camera:CameraObject3D, sorted:Array = null) : Number
      {
         var p:Particle = null;
         var fz:Number = NaN;
         super.project(parent,camera,sorted);
         fz = camera.focus * camera.zoom;
         for each(p in particles)
         {
            if(scene.particleCuller.testParticle(p))
            {
               p.renderScale = fz / (camera.focus + p.vertex3D.vertex3DInstance.z);
               p.renderCommand.screenDepth = p.vertex3D.vertex3DInstance.z;
               scene.renderer.addToRenderList(p.renderCommand);
            }
         }
         return 1;
      }
      
      public function removeParticle(particle:Particle) : void
      {
         particle.instance = null;
         particles.splice(particles.indexOf(particle,0));
         vertices.splice(vertices.indexOf(particle.vertex3D,0));
      }
      
      public function addParticle(particle:Particle) : void
      {
         particle.instance = this;
         particles.push(particle);
         vertices.push(particle.vertex3D);
      }
      
      public function removeAllParticles() : void
      {
         particles = new Array();
         vertices = new Array();
         geometry.vertices = vertices;
      }
   }
}

