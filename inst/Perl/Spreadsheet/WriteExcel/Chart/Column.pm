package Spreadsheet::WriteExcel::Chart::Column;

###############################################################################
#
# Column - A writer class for Excel Column charts.
#
# Used in conjunction with Spreadsheet::WriteExcel::Chart.
#
# See formatting note in Spreadsheet::WriteExcel::Chart.
#
# Copyright 2000-2010, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

require Exporter;

use strict;
use Spreadsheet::WriteExcel::Chart;


use vars qw($VERSION @ISA);
@ISA = qw(Spreadsheet::WriteExcel::Chart Exporter);

$VERSION = '2.39';

###############################################################################
#
# new()
#
#
sub new {

    my $class = shift;
    my $self  = Spreadsheet::WriteExcel::Chart->new( @_ );

    bless $self, $class;
    return $self;
}


###############################################################################
#
# _store_chart_type()
#
# Implementation of the abstract method from the specific chart class.
#
# Write the BAR chart BIFF record. Defines a bar or column chart type.
#
sub _store_chart_type {

    my $self = shift;

    my $record    = 0x1017;    # Record identifier.
    my $length    = 0x0006;    # Number of bytes to follow.
    my $pcOverlap = 0x0000;    # Space between bars.
    my $pcGap     = 0x0096;    # Space between cats.
    my $grbit     = 0x0000;    # Option flags.

    my $header = pack 'vv', $record, $length;
    my $data = '';
    $data .= pack 'v', $pcOverlap;
    $data .= pack 'v', $pcGap;
    $data .= pack 'v', $grbit;

    $self->_append( $header, $data );
}


1;


__END__


=head1 NAME

Column - A writer class for Excel Column charts.

=head1 SYNOPSIS

To create a simple Excel file with a Column chart using Spreadsheet::WriteExcel:

    #!/usr/bin/perl -w

    use strict;
    use Spreadsheet::WriteExcel;

    my $workbook  = Spreadsheet::WriteExcel->new( 'chart.xls' );
    my $worksheet = $workbook->add_worksheet();

    my $chart     = $workbook->add_chart( type => 'column' );

    # Configure the chart.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Add the worksheet data the chart refers to.
    my $data = [
        [ 'Category', 2, 3, 4, 5, 6, 7 ],
        [ 'Value',    1, 4, 5, 2, 1, 5 ],
    ];

    $worksheet->write( 'A1', $data );

    __END__

=head1 DESCRIPTION

This module implements Column charts for L<Spreadsheet::WriteExcel>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'column' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_x_axis();
    $chart->set_y_axis();
    $chart->set_title();

These methods are explained in detail in L<Spreadsheet::WriteExcel::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Column Chart Methods

There aren't currently any column chart specific methods. See the TODO section of L<Spreadsheet::WriteExcel::Chart>.

=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a chart.

    #!/usr/bin/perl -w

    use strict;
    use Spreadsheet::WriteExcel;

    my $workbook  = Spreadsheet::WriteExcel->new( 'chart_column.xls' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Number', 'Sample 1', 'Sample 2' ];
    my $data = [
        [ 2, 3, 4, 5, 6, 7 ],
        [ 1, 4, 5, 2, 1, 5 ],
        [ 3, 6, 7, 5, 4, 3 ],
    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'column', embedded => 1 );

    # Configure the first series. (Sample 1)
    $chart->add_series(
        name       => 'Sample 1',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Configure the second series. (Sample 2)
    $chart->add_series(
        name       => 'Sample 2',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$C$2:$C$7',
    );

    # Add a chart title and some axis labels.
    $chart->set_title ( name => 'Results of sample analysis' );
    $chart->set_x_axis( name => 'Test number' );
    $chart->set_y_axis( name => 'Sample length (cm)' );

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'D2', $chart, 25, 10 );

    __END__


=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://homepage.eircom.net/~jmcnamara/perl/images/column1.jpg" width="527" height="320" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMX, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

