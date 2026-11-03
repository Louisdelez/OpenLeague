import copy
import unittest
from consumer_scope import consumer_scope_exclusions, consumer_instruction_line


class ConsumerScopeTests(unittest.TestCase):
    def setUp(self):
        self.consumer = dict(consumer_id='c', path='world.rs', line=185,
                             role='world_loader', scope='Map10')
        self.entry = dict(consumer_id='c', kind='outside_requirement_scope',
                          provides_feature_consumer=False, reason='Map10 uniquement',
                          evidence_source_id='s', evidence_selector='/associations/0')
        self.row = dict(current_consumers=['c'], unknown_ids=['u'],
                        reference_inputs=[dict(source_id='s', selector='/associations/0',
                                               relation='consumer_requirement_scope_evidence')],
                        consumer_scope_exclusions=[self.entry])

    def test_same_consumer_different_requirement(self):
        original = copy.deepcopy(self.consumer)
        scoped = consumer_scope_exclusions(self.row, {'c': self.consumer})
        self.assertIn('hors périmètre', consumer_instruction_line(self.consumer, '.', scoped['c']))
        unrelated = copy.deepcopy(self.row)
        unrelated.pop('consumer_scope_exclusions')
        self.assertEqual(consumer_scope_exclusions(unrelated, {'c': self.consumer}), {})
        self.assertIn('Consommateur actuel', consumer_instruction_line(self.consumer, '.'))
        self.assertEqual(self.consumer, original)

    def test_invalid_evidence_and_false_completion_refused(self):
        changes = [dict(evidence_selector='/another'), dict(evidence_source_id='absent'),
                   dict(reason=' '), dict(provides_feature_consumer=True),
                   dict(kind='feature_complete'), dict(consumer_id='missing')]
        for change in changes:
            with self.subTest(change=change):
                row = copy.deepcopy(self.row)
                row['consumer_scope_exclusions'][0].update(change)
                with self.assertRaises(ValueError):
                    consumer_scope_exclusions(row, {'c': self.consumer})

    def test_duplicate_unlinked_and_resolved_exclusions_refused(self):
        for field,value in [('consumer_scope_exclusions',[self.entry,self.entry]),
                            ('consumer_scope_exclusions',{}),('current_consumers',[]),
                            ('reference_inputs',[]),('unknown_ids',[])]:
            with self.subTest(field=field):
                row=copy.deepcopy(self.row);row[field]=value
                with self.assertRaises(ValueError):
                    consumer_scope_exclusions(row, {'c':self.consumer})


if __name__ == '__main__':
    unittest.main(verbosity=2)
