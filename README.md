# policy-elasticsearch-container

This is a base image intended for use with Policy components that require an Elasticsearch installation.

## Configuring Elasticsearch

Elasticsearch must be configured by executing a script provided by this base image, located at `/opt/elasticsearchConfig/configureElasticsearch.sh`.

The configuration script uses default Elasticsearch configuration settings. These may be overridden by specifying the location of an alternative Elasticsearch configuration file using the environment variable `ELASTICSEARCH_CONFIG_FILE` or by providing an alternative Elasticsearch configuration file in the Mesos mount location: `/mnt/mesos/sandbox/elasticsearch.yml`.

### Configuring Elasticsearch logging
The Elasticsearch logging level may be overridden using the system property `es.logger.level`. The possible levels are:

 * WARN
 * ERROR
 * INFO
 * TRACE
 * DEBUG
 * ALL

For more detailed control over Elasticsearch logging, the default Elasticsearch logging configuration may be overridden by specifying the location of an alternative Elasticsearch logging configuration file using the environment variable `ELASTICSEARCH_LOGGING_FILE` or by providing an alternative Elasticsearch logging configuration file in the Mesos mount location: `/mnt/mesos/sandbox/logging.yml`.
