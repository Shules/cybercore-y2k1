import sys
sys.dont_write_bytecode = True
import importlib.machinery, importlib.util, tempfile
from pathlib import Path
loader=importlib.machinery.SourceFileLoader('state',str(Path(__file__).resolve().parents[1]/'scripts/cybercore-state'));spec=importlib.util.spec_from_loader(loader.name,loader);m=importlib.util.module_from_spec(spec);loader.exec_module(m)
with tempfile.TemporaryDirectory() as t:
 t=Path(t);home=t/'home';home.mkdir();dest=t/'backup'
 try:m.backup(home,dest);raise AssertionError('accepted empty backup')
 except ValueError:pass
 for r in m.REQUIRED:
  p=home/r;p.parent.mkdir(parents=True,exist_ok=True);p.write_text('original '+r)
 binary=home/'.local/bin/tm';binary.parent.mkdir(parents=True);binary.write_text('original timer');binary.chmod(0o751)
 unrelated=home/'.local/bin/unrelated';unrelated.write_text('keep');unrelated.chmod(0o640)
 m.backup(home,dest);m.validate(dest)
 try:m.backup(home,dest);raise AssertionError('existing destination accepted')
 except ValueError:pass
 target=home/'.config/kwinrc';target.write_text('changed')
 m.restore(home,dest,False);assert target.read_text()=='changed'
 real=m.os.replace;calls=[0]
 def fail(src,dst):
  calls[0]+=1
  if calls[0]==4:raise OSError('injected replacement failure')
  return real(src,dst)
 m.os.replace=fail
 try:m.restore(home,dest,True);raise AssertionError('missing failure')
 except OSError:pass
 finally:m.os.replace=real
 assert target.read_text()=='changed','rollback did not restore original state'
 m.restore(home,dest,True);assert target.read_text()=='original .config/kwinrc';assert binary.stat().st_mode&0o777==0o751;assert unrelated.stat().st_mode&0o777==0o640
 (dest/'payload/.config/kwinrc').write_text('corrupted')
 try:m.restore(home,dest,True);raise AssertionError('corruption accepted')
 except ValueError:pass
 assert target.read_text()=='original .config/kwinrc'
 print('PASS: empty source, existing destination, dry run, failure rollback, restore, permissions, corruption')
