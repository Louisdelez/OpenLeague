"""Unique ownership of deferred native callback entries under reentrancy.

An interrupted callback is recorded, never automatically retried: its native
body may already have changed ownership. Unstarted entries remain queued.
"""
def drain_one_batch(pending,interrupted,invoke):
    batch=list(pending);pending.clear()
    for index,entry in enumerate(batch):
        try:invoke(entry)
        except BaseException as error:
            pending[:0]=batch[index+1:]
            interrupted.append({'entry':dict(entry),'error':repr(error),'state':'native_callback_interrupted_do_not_retry_implicitly'})
            raise
