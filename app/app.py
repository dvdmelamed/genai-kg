import streamlit as st
from langchain_community.chat_models import ChatOpenAI
from langchain_community.llms import Bedrock
from langchain.chains import NeptuneOpenCypherQAChain
from dotenv import load_dotenv
from os import environ
from langchain_community.graphs import NeptuneGraph

MODEL_OPENAI_GPT4 = 'gpt-4'
MODEL_ANTHROPIC_CLAUDE2 = 'anthropic.claude-v2:1'

load_dotenv()
openai_api_key = environ.get('OPENAI_AI_KEY')

genai_model_id = environ.get('GENAI_MODEL_ID')
host = environ.get("NEPTUNE_HOST")
port = int(environ.get("NEPTUNE_PORT"))

graph = NeptuneGraph(host=host, port=port, use_https=True)

st.title('The EngiHub')

def is_model_supported(model_id):
  return model_id in [MODEL_OPENAI_GPT4, MODEL_ANTHROPIC_CLAUDE2]

def get_cypher_qa_template():
  return """## Cypher Query Generation
    - Do not use `NONE`, `ALL` or `ANY` predicate function, rather use list comprehension.
    - Do not use `REDUCE` function. Rather use a combination of list comprehension and `UNWIND` clause to achieve similar results.
    - Do not use `FOREACH` clause. Rather use a combination of `WITH` and `UNWIND` clauses to achieve similar results.
    - Use only the provided relationship types and properties in the schema.
    - Encapsulate all the labels in the query with backtick signs."""

def generate_response(input_text):
  if not is_model_supported(genai_model_id):
    st.warning('Please enter a valid model ID!', icon='⚠')
    return None

  if genai_model_id == MODEL_OPENAI_GPT4:
    if not openai_api_key.startswith('sk-'):
      st.warning('Please enter your OpenAI API key!', icon='⚠')
      return None

    llm = ChatOpenAI(temperature=0, model=MODEL_OPENAI_GPT4, openai_api_key=openai_api_key)
  else:
    model_kwargs = dict(temperature=0, top_k=250, top_p=1)
    llm = Bedrock(model_id=genai_model_id,model_kwargs=model_kwargs)

  chain = NeptuneOpenCypherQAChain.from_llm(
    llm=llm,
    graph=graph,
    verbose=True,
    extra_instructions=get_cypher_qa_template()
  )
  r = chain.invoke(input_text)
  return r['result']

with st.form('query_form'):
  # Initial question
  text = st.text_area('Enter text:', 'Can you list the EC2 machines?')
  submitted = st.form_submit_button('Submit')

  response = generate_response(text)
  if response is not None:
    st.info(response)
