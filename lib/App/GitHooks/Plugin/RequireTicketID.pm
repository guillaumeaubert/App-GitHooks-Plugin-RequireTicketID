package App::GitHooks::Plugin::RequireTicketID;

use strict;
use warnings;

use base 'App::GitHooks::Plugin';

# Internal dependencies.
use App::GitHooks::Constants qw( :PLUGIN_RETURN_CODES );


=head1 NAME

App::GitHooks::Plugin::RequireTicketID - Require a ticket ID in the commit message.


=head1 DESCRIPTION

If you are using a ticketing system, it is very useful to make sure that all
your commit messages include a ticket ID to provide more context into why the
code is being changed.


=head1 VERSION

Version 1.0.0

=cut

our $VERSION = '1.0.0';


=head1 METHODS

=head2 run_commit_msg()

Code to execute as part of the commit-msg hook.

  my $success = App::GitHooks::Plugin::RequireTicketID->run_commit_msg();

=cut

sub run_commit_msg
{
	my ( $class, %args ) = @_;
	my $commit_message = delete( $args{'commit_message'} );
	my $app = delete( $args{'app'} );

	# We must have a ticket ID.
	my $ticket_id = $commit_message->get_ticket_id();
	if ( !defined( $ticket_id ) )
	{
		my $failure_character = $app->get_failure_character();
		my $indent = '    ';
		print $app->color( 'red', $failure_character . " Your commit needs to start with one of the following:\n" );
		print $app->wrap( "- for FogBugz tickets, 'FB1234: '\n", $indent );
		print $app->wrap( "- for JIRA tickets, 'TL-1234: '\n", $indent );
		print $app->wrap( "- if no ticket is truly applicable, '--: '\n", $indent );
		return $PLUGIN_RETURN_FAILED;
	}

	return $PLUGIN_RETURN_PASSED;
}


=head1 BUGS

Please report any bugs or feature requests through the web interface at
L<https://github.com/guillaumeaubert/App-GitHooks-Plugin-RequireTicketID/issues/new>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc App::GitHooks::Plugin::RequireTicketID


You can also look for information at:

=over

=item * GitHub's request tracker

L<https://github.com/guillaumeaubert/App-GitHooks-Plugin-RequireTicketID/issues>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/app-githooks-plugin-requireticketid>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/app-githooks-plugin-requireticketid>

=item * MetaCPAN

L<https://metacpan.org/release/App-GitHooks-Plugin-RequireTicketID>

=back


=head1 AUTHOR

L<Guillaume Aubert|https://metacpan.org/author/AUBERTG>,
C<< <aubertg at cpan.org> >>.


=head1 COPYRIGHT & LICENSE

Copyright 2013-2014 Guillaume Aubert.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see http://www.gnu.org/licenses/

=cut

1;
