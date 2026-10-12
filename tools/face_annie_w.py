from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/main.rs');s=p.read_text(encoding='utf-8');a='''                        transform.translation = position;
                    }
                    if connection.id == Some(p.id)''';b='''                        if let Some(cast)=&p.effects.annie_w {
                            entity_orientation::apply(&mut transform,[cast.direction.x,0.,cast.direction.z]);
                        }
                        transform.translation = position;
                    }
                    if connection.id == Some(p.id)''';assert a in s;s=s.replace(a,b);p.write_text(s,encoding='utf-8')
print('Pending W now drives native entity yaw, including stationary casters; visual fidelity remains unqualified')
