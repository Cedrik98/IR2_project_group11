import json
from tqdm import tqdm


def prepare_corpus(input_file, output_file):
    corpus = {}
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in tqdm(infile):
            data = json.loads(line)
            for passage in data.get('positive_passages', []):
                passage_id = passage['docid']
                if passage_id not in corpus:  # Ensure unique passages
                    corpus[passage_id] = passage['text']
        for passage_id, text in corpus.items():
            outfile.write(json.dumps({"id": passage_id, "contents": text}) + "\n")


def prepare_queries(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            data = json.loads(line)
            query = {"id": data['query_id'], "text": data['query']}
            outfile.write(json.dumps(query) + "\n")


prepare_queries("scifact_first.jsonl", "scifact_queries.jsonl")
prepare_corpus("scifact_first.jsonl", "scifact_corpus.jsonl")
