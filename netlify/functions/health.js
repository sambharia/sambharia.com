function json(statusCode, body) {
  return {
    statusCode,
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Cache-Control': 'public, max-age=60',
      'Vary': 'Accept',
      'Access-Control-Allow-Origin': '*',
    },
    body: JSON.stringify(body),
  };
}

exports.handler = async (event) => {
  if (event.httpMethod !== 'GET') {
    return json(405, {
      error: {
        code: 'METHOD_NOT_ALLOWED',
        message: `The ${event.httpMethod || 'requested'} method is not supported.`,
        resolution: 'Use GET /api/health.',
      },
    });
  }

  return json(200, {
    status: 'ok',
    service: 'sambharia.com',
    docs: 'https://sambharia.com/api/openapi.yaml',
  });
};
