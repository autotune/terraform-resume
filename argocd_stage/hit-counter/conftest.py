import server 
import pytest


flask_app = server.app

@pytest.fixture(scope='module')
def client():
    with flask_app.test_client() as c:
        yield c


def test_backend(client):
    """ Test to see we get a 200 response on main site """
    response = client.get('/')
    assert response.status_code == 200
