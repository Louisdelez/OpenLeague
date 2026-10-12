//! Bounded default Map10 projection read from original 8008F0 / 8009F0.
//! Static port, not an executed original minimap/draw qualification.
use bevy::prelude::*;
use openleague_core::Point;

#[derive(Clone,Copy,Debug,PartialEq)]
pub(super) struct Rect {pub left:f32,pub top:f32,pub width:f32,pub height:f32}
impl Rect {
    pub fn from_node(node:&Node)->Result<Self,String> {
        let (Val::Px(left),Val::Px(top),Val::Px(width),Val::Px(height))=(node.left,node.top,node.width,node.height)
            else {return Err("minimap requires the original pixel rectangle".into());};
        let out=Self{left,top,width,height};
        if ![left,top,width,height].iter().all(|v|v.is_finite()) || width<=0. || height<=0. {return Err("invalid minimap rectangle".into());}
        Ok(out)
    }
    pub fn contains(self,p:Vec2)->bool {p.is_finite() && p.x>=self.left && p.y>=self.top && p.x<self.left+self.width && p.y<self.top+self.height}
    pub fn bits(self)->[u32;4] {[self.left,self.top,self.width,self.height].map(f32::to_bits)}
}
#[derive(Clone,Copy)]
pub(super) struct Projection {span:[f32;2],pan:[f32;2]}
impl Projection {
    pub fn map10()->Result<Self,String> {
        let bounds=crate::fow_level_bounds::LevelBounds::from_scb(include_bytes!("../../../assets/maps/tt_level_size.scb"))?;
        let g=bounds.view_geometry();
        // Only the original default Map10 controller: zero X/Z minimum, zoom1,
        // pan at the level center. No inferred atlas crop or reflected map root.
        if bounds.min[0]!=0. || bounds.min[2]!=0. || !g.span[0].is_finite() || !g.span[2].is_finite()
            || g.span[0]<=0. || g.span[2]<=0. {return Err("unsupported minimap level bounds".into());}
        Ok(Self{span:[g.span[0],g.span[2]],pan:[g.center[0],g.center[2]]})
    }
    pub fn project(self,r:Rect,p:Point)->Option<Vec2> {
        if !p.finite() {return None;}
        let z=(p.z-self.pan[1])/self.span[1];let x=(p.x-self.pan[0])/self.span[0];
        let y=(r.height*0.5+r.top)-z*r.height;
        let x=x*r.width+(r.width*0.5+r.left);
        let result=Vec2::new(x,y);
        (result.is_finite() && x>=r.left && x<=r.left+r.width && y>=r.top && y<=r.top+r.height).then_some(result)
    }
    pub fn inverse(self,r:Rect,p:Vec2)->Option<Point> {
        if !r.contains(p) {return None;}
        let dx=p.x-(r.width*0.5+r.left);let dy=p.y-(r.height*0.5+r.top);
        let out=Point{x:dx*self.span[0]/r.width+self.pan[0],z:-(self.span[1]*dy/r.height)+self.pan[1]};
        out.finite().then_some(out)
    }
}
